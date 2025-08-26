import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_event.dart';
import '../blocs/login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Successful ✅")),
                  );
                } else if (state.status == LoginStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Credentials ❌")),
                  );
                }
              },
              builder: (context, state) {
                final bloc = context.read<LoginBloc>();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "WalletWise",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text("Login", style: TextStyle(fontSize: 24)),

                    const SizedBox(height: 24),

                    // Email
                    TextField(
                      onChanged: (value) =>
                          bloc.add(EmailChanged(value)),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      onChanged: (value) =>
                          bloc.add(PasswordChanged(value)),
                      obscureText: !state.showPassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(state.showPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              bloc.add(TogglePasswordVisibility()),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forget Password?"),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.status == LoginStatus.loading
                            ? null
                            : () => bloc.add(LoginSubmitted()),
                        child: state.status == LoginStatus.loading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text("Or Login With"),
                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text("Continue with Google"),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      label: const Text("Continue with Apple"),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Sign Up"),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
