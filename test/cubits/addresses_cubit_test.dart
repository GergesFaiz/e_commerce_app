import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/addresses/data/models/address_model.dart';
import 'package:e_commerce/features/addresses/domain/addresses_repository.dart';
import 'package:e_commerce/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAddressesRepo implements IAddressesRepo {
  FakeAddressesRepo(this.items);
  List<Address> items;

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    return Right(List.of(items));
  }

  @override
  Future<Either<Failure, String>> addAddress(Address address) async {
    items = [...items, address];
    return const Right('Address added');
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    items = items.where((a) => a.id != id).toList();
    return const Right(null);
  }
}

const _home = Address(
    id: 'a1', name: 'Home', details: 'St 11', phone: '0100', city: 'Cairo');

void main() {
  AddressesCubit buildCubit(List<Address> items) {
    final repo = FakeAddressesRepo(items);
    return AddressesCubit(
        GetAddressesUseCase(repo), AddAddressUseCase(repo), DeleteAddressUseCase(repo));
  }

  test('loads addresses and preselects the first', () async {
    final cubit = buildCubit([_home]);

    await cubit.load();

    final state = cubit.state as AddressesLoaded;
    expect(state.addresses.length, 1);
    expect(state.selectedId, 'a1');
  });

  test('adds an address and reloads', () async {
    final cubit = buildCubit([_home]);

    await cubit.load();
    final ok = await cubit.add(const Address(
        id: 'a2', name: 'Work', details: 'St 5', phone: '0111', city: 'Giza'));

    expect(ok, isTrue);
    expect((cubit.state as AddressesLoaded).addresses.length, 2);
  });
}
