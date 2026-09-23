import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/core/di/base_usecase.dart';

import '../../data/models/address_model.dart';
import '../../domain/addresses_repository.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();
  @override
  List<Object?> get props => [];
}

class AddressesInitial extends AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<Address> addresses;
  final String? selectedId;
  const AddressesLoaded(this.addresses, {this.selectedId});
  @override
  List<Object?> get props => [addresses, selectedId];
}

class AddressesFailure extends AddressesState {
  final String message;
  const AddressesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AddressesCubit extends Cubit<AddressesState> {
  final GetAddressesUseCase _get;
  final AddAddressUseCase _add;
  final DeleteAddressUseCase _remove;
  AddressesCubit(this._get, this._add, this._remove)
      : super(AddressesInitial());

  Future<void> load() async {
    emit(AddressesLoading());
    final r = await _get(NoParams());
    r.fold(
      (f) => emit(AddressesFailure(f.message)),
      (list) => emit(AddressesLoaded(list,
          selectedId: list.isEmpty ? null : list.first.id)),
    );
  }

  void select(String? id) {
    final s = state;
    if (s is AddressesLoaded) emit(AddressesLoaded(s.addresses, selectedId: id));
  }

  Future<bool> add(Address address) async {
    final r = await _add(address);
    var ok = false;
    await r.fold(
      (_) async => ok = false,
      (_) async {
        ok = true;
        await load();
      },
    );
    return ok;
  }

  Future<void> remove(String id) async {
    await _remove(id);
    await load();
  }
}
