import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'credit_note_events.dart';
part 'credit_note_states.dart';

class CreditNoteBloc extends Bloc<CreditNoteEvents, CreditNoteStates> {
  Repository repository = Repository.getInstance();
  BaseBloc baseBloc;

  CreditNoteBloc(this.baseBloc) : super(CreditNoteInitialState());

  @override
  Stream<CreditNoteStates> mapEventToState(CreditNoteEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
