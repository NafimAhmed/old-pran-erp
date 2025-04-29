import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_list_bloc.dart';

class OpmC21Screen extends StatelessWidget {
  const OpmC21Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-21-SCREEN";
  static const String routePath = "/OPM-C-21-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ChatListBloc(getService()),
        ),
      ],
      child: OpmC21ScreenBody(
        fromName: fromName,
      ),
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
  late ScrollController chatScroll;
  @override
  void initState() {
    chatScroll = ScrollController();
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    askTextController = TextEditingController();
    context.read<ChatListBloc>().add(
          GetConversation(
            userId: loggedUser.userId,
          ),
        );

    super.initState();
  }

  @override
  void dispose() {
    askTextController.dispose();
    super.dispose();
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
                askTextController.clear();
                context.read<ChatListBloc>().add(
                      GetConversation(
                        userId: loggedUser.userId,
                      ),
                    );
              }
            },
          ),
          BlocListener<ChatListBloc, ChatListState>(
            listener: (context, state) {
              if (state is ChatListSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  chatScroll.jumpTo(chatScroll.position.maxScrollExtent);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(179, 214, 246, 0.16),
                  ),
                  child: BlocBuilder<ChatListBloc, ChatListState>(
                    builder: (context, state) {
                      if (state is ChatListSuccess) {
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
                            return ReceivedMessage(message: data.askText ?? "");
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
                  left: 20,
                  right: 20,
                  top: 15,
                  bottom: 15,
                ),
                color: const Color.fromRGBO(179, 214, 246, 0.16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        controller: askTextController,
                        hintText: "Type Here",
                        fillColor: appTheme.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.read<ChatBloc>().add(
                              SendMessage(
                                userId: loggedUser.userId,
                                askText: askTextController.text,
                              ),
                            );
                      },
                      child: Container(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 247,
            ),
            padding: const EdgeInsets.all(20),
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
              style: textTheme.bodySmall!.copyWith(
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
  const ReceivedMessage({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(ImageConstant.malePlaceholder),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 247,
                ),
                padding: const EdgeInsets.all(20),
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
                child: Text(
                  message,
                  textAlign: TextAlign.left,
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
