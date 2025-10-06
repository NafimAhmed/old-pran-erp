import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_22_screen/bloc/typing_bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class OpmC21Screen extends StatelessWidget {
  const OpmC21Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-21-SCREEN";
  static const String routePath = "/OPM-C-21-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc(getService())),
        BlocProvider(create: (context) => ChatListBloc(getService())),
      ],
      child: OpmC21ScreenBody(fromName: fromName),
    );
  }
}

class OpmC21ScreenBody extends StatefulWidget {
  const OpmC21ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC21ScreenBody> createState() => _OpmC21ScreenBodyState();
}

class _OpmC21ScreenBodyState extends State<OpmC21ScreenBody> {
  late UserInfoModel loggedUser;
  late TextEditingController askTextController;
  late FocusNode askFocusNode;
  late ScrollController chatScroll;
  Map<int, TypingBloc> typeBlocMap = {};
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isButtonHeld = false;
  String _lastWords = "";

  @override
  void initState() {
    super.initState();
    chatScroll = ScrollController();
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    askTextController = TextEditingController();
    askFocusNode = FocusNode();
    context.read<ChatListBloc>().add(
      GetConversation(userId: loggedUser.userId),
    );
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  @override
  void dispose() {
    askTextController.dispose();
    askFocusNode.dispose();
    chatScroll.dispose();

    super.dispose();
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        _requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        break;
    }
  }

  Future<void> _requestForPermission() async {
    await Permission.microphone.request();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: _statusListener, //  listen to status
      onError: (error) {
        debugPrint("Speech error: $error");
      },
    );
    setState(() {});
  }

  void _statusListener(String status) {
    if (_isButtonHeld) {
      _startListening(); // restart if still holding
    }
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60), // max per session
      pauseFor: const Duration(seconds: 1),
      localeId: "en_US",
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      askTextController.text = _lastWords;
    });
  }

  List<GptInfo> conversation = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //Qr Reprint
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatSuccess) {
                // context.read<ChatListBloc>().add(
                //   GetConversation(userId: loggedUser.userId),
                // );
              }
            },
          ),
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  chatScroll.animateTo(
                    chatScroll.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              }
            },
          ),
        ],
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(179, 214, 246, 0.16),
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatSuccess) {
                        conversation = state.conversation;
                      }
                      return ListView.separated(
                        controller: chatScroll,
                        itemCount: conversation.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          var data = conversation[index];
                          if (data.chatOwner == "SYSTEM") {
                            return ReceivedMessage(
                              message: data.askText ?? "",
                              typIngBloc: typeBlocMap.putIfAbsent(
                                index,
                                () => TypingBloc(getService())
                                  ..add(
                                    StartTyping(
                                      message: data.askText ?? "",
                                      typeAble:
                                          index == conversation.length - 1,
                                    ),
                                  ),
                              ),
                            );
                          } else {
                            return SentMessage(message: data.askText ?? "");
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 15,
                  bottom: 15,
                ),
                color: const Color.fromRGBO(179, 214, 246, 0.16),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        controller: askTextController,
                        focusNode: askFocusNode,
                        textAlign: TextAlign.left,
                        hintText: "Type Here",
                        maxLines: 2,

                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                List<PlatformFile>? pickedFiles;

                                try {
                                  pickedFiles =
                                      (await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowMultiple: false,
                                        allowedExtensions: [
                                          'jpg',
                                          'pdf',
                                          'doc',
                                          'png',
                                          'xlsx',
                                        ],
                                      ))?.files;
                                } on PlatformException catch (e) {
                                  log('Unsupported operation: $e');
                                } catch (e) {
                                  log(e.toString());
                                }

                                if (pickedFiles != null) {
                                  PlatformFile file = pickedFiles.first;

                                  print(file.name);
                                  print(file.bytes);
                                  print(file.size);
                                  print(file.extension);
                                  print(file.path);
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appTheme.white,
                                  border: Border.all(
                                    color: appTheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.attach_file_rounded,
                                  color: appTheme.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  if (askTextController.text.isEmpty) {
                                    return;
                                  }
                                  var bloc;
                                  if (typeBlocMap.isNotEmpty) {
                                    bloc = typeBlocMap.values.last;
                                  }

                                  if (bloc != null && bloc.state.completed) {
                                    context.read<ChatBloc>().add(
                                      SendMessage(
                                        userId: loggedUser.userId,
                                        askText: askTextController.text,
                                      ),
                                    );
                                    askTextController.clear();
                                  } else if (typeBlocMap.isEmpty) {
                                    context.read<ChatBloc>().add(
                                      SendMessage(
                                        userId: loggedUser.userId,
                                        askText: askTextController.text,
                                      ),
                                    );
                                    askTextController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Please wait for the previous message to complete.",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 5,
                                    left: 5,
                                  ),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: appTheme.primary,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.send,
                                      color: appTheme.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        fillColor: appTheme.white,
                        filled: true,
                      ),
                    ),
                    _buildMicButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onLongPressStart: (details) {
        if (_speechEnabled && !_speechToText.isListening) {
          _isButtonHeld = true; //  start holding
          _startListening();
        }
      },
      onLongPressEnd: (details) {
        _isButtonHeld = false; //  stop holding
        _lastWords = "";
        _stopListening();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _speechToText.isNotListening
              ? appTheme.white
              : appTheme.primary,
          border: Border.all(color: appTheme.primary, width: 1.5),
        ),
        child: Icon(
          size: 30,
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
        ),
      ),
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 247),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.4),
                width: 0.5,
              ),
              color: appTheme.primary,
            ),
            child: Text(
              message,
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium!.copyWith(
                fontSize: 18,
                color: appTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "sent",
                textAlign: TextAlign.left,
                style: textTheme.bodySmall!.copyWith(
                  color: appTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "1:39 PM",
                textAlign: TextAlign.left,
                style: textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  final String message;
  final TypingBloc typIngBloc;
  final bool isTyping;
  const ReceivedMessage({
    super.key,
    required this.message,
    required this.typIngBloc,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: typIngBloc,
      child: ReceivedMessageContent(message: message),
    );
  }
}

class ReceivedMessageContent extends StatefulWidget {
  const ReceivedMessageContent({super.key, required this.message});
  final String message;

  @override
  State<ReceivedMessageContent> createState() => _ReceivedMessageContentState();
}

class _ReceivedMessageContentState extends State<ReceivedMessageContent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4),
                    width: 0.5,
                  ),
                  color: appTheme.white,
                ),
                child: BlocBuilder<TypingBloc, TypingState>(
                  builder: (context, state) {
                    return HtmlWidget(
                      state.typedText,
                      textStyle: textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                    // return Text(
                    //   state.typedText,
                    //   textAlign: TextAlign.left,
                    //   style: textTheme.bodySmall!.copyWith(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 18,
                    //   ),
                    // );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "1:39 PM",
                textAlign: TextAlign.left,
                style: textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
