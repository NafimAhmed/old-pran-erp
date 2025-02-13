import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/user_profile/user_profile_screen/bloc/user_pass_chang_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  static const String routeName = "user-profile-screen";
  static const String routePath = "user-profile-screen";
  @override
  Widget build(BuildContext context) {
    return const UserProfileScreenBody();
  }
}

class UserProfileScreenBody extends StatefulWidget {
  const UserProfileScreenBody({super.key});

  @override
  State<UserProfileScreenBody> createState() => _UserProfileScreenBodyState();
}

class _UserProfileScreenBodyState extends State<UserProfileScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(appBartitle: "Profile"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appTheme.primary,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appTheme.white,
                      width: 2,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        ImageConstant.malePlaceholder,
                      ),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                BlocBuilder<LoggedUserInfoCubit, UserInfoModel?>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state != null ? state.userName : "",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                        Text(
                          "ID: ${state != null ? state.userId : ""}",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ProfileMenuWidget(
                  title: "Change Password",
                  onTap: () {
                    AppModal.showCustomModal(
                      context,
                      content: ChangePasswordDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserPassChangBloc(getService()),
      child: const ChangePasswordDialogContent(),
    );
  }
}

class ChangePasswordDialogContent extends StatefulWidget {
  const ChangePasswordDialogContent({
    super.key,
  });

  @override
  State<ChangePasswordDialogContent> createState() =>
      _ChangePasswordDialogContentState();
}

class _ChangePasswordDialogContentState
    extends State<ChangePasswordDialogContent> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _conPasswordController;
  late FocusNode _oldPasswordFocusNode;
  late FocusNode _newPasswordFocusNode;
  late FocusNode _conPasswordFocusNode;

  bool _oldVisiable = true;
  bool _newVisiable = true;
  bool _conVisiable = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _conPasswordController = TextEditingController();
    _oldPasswordFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
    _conPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _conPasswordController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _conPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPassChangBloc, UserPassChangState>(
      listener: (context, state) {
        if (state is UserPassChangSuccess) {
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _conPasswordController.clear();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.successSnackber(
              message: "Password Changed Successfully!",
            ),
          );
        }
        if (state is UserPassChangError) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.errorSnackber(
              message: state.error.toString(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonDialogHeader(title: "Change Password"),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonTextFieldWidget(
                    obscureText: _oldVisiable,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _oldVisiable = !_oldVisiable;
                        });
                      },
                      child: Icon(
                        _oldVisiable
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: appTheme.primary,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _oldPasswordController,
                    focusNode: _oldPasswordFocusNode,
                    labelText: "Old Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Old Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextFieldWidget(
                    obscureText: _newVisiable,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _newVisiable = !_newVisiable;
                        });
                      },
                      child: Icon(
                        _newVisiable
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: appTheme.primary,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    labelText: "New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter New Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextFieldWidget(
                    obscureText: _conVisiable,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _conVisiable = !_conVisiable;
                        });
                      },
                      child: Icon(
                        _conVisiable
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: appTheme.primary,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _conPasswordController,
                    focusNode: _conPasswordFocusNode,
                    labelText: "Confirm Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Confirm Password";
                      } else if (value != _newPasswordController.text) {
                        return "Password Doesn't Match";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<UserPassChangBloc, UserPassChangState>(
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom().copyWith(
                    padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(80, 30),
                    ),
                    backgroundColor: WidgetStatePropertyAll(appTheme.tertiary),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<UserPassChangBloc>().add(
                            UserPassChang(
                              userid: loggedUser.userId,
                              oldPass: _oldPasswordController.text,
                              newPass: _newPasswordController.text,
                            ),
                          );
                    }
                  },
                  child: Text(
                    state is UserPassChangLoading
                        ? "Changing..."
                        : "Change Password",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    this.onTap,
  });
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: appTheme.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appTheme.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: appTheme.white,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
