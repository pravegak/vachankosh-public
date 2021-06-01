import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationSearchService {
  Future<Address> getLocationDetails(Prediction p) async {
    if (p != null) {
      // PlacesDetailsResponse detail =
      //     await _places.getDetailsByPlaceId(p.placeId);

      // var placeId = p.placeId;
      // double lat = detail.result.geometry.location.lat;
      // double lng = detail.result.geometry.location.lng;
      var addresses =
          await Geocoder.local.findAddressesFromQuery(p.description);
      return addresses.first;
    }
    return null;
  }
}
