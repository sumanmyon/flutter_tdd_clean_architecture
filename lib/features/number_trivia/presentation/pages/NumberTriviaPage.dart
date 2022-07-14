import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/InjectionContainer.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.call<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              //Top Half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (ctx, state) {
                  if (state is Empty) {
                    return MessageDisplayWidget(
                      message: "Start Searching!",
                    );
                  } else if (state is Error) {
                    return MessageDisplayWidget(
                      message: "${state.message}",
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplayWidget(
                      numberTrivia: state.trivia,
                    );
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                  );
                },
              ),

              SizedBox(height: 20),

              //Bottom Half
              TriviaControlsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControlsWidget extends StatelessWidget {
  const TriviaControlsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Placeholder(fallbackHeight: 40),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Placeholder(fallbackHeight: 30),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Placeholder(fallbackHeight: 30),
            ),
          ],
        ),
      ],
    );
  }
}






