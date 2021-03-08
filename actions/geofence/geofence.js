function main(params) {

    // Execute logic to enforce geofence if required parameters are present
    if(params.latitude && params.longitude && params.center_latitude && params.center_longitude && params.geofence_radius) {


      var R = 6371e3; // metres
      var φ1 = degrees_to_radians(params.center_latitude);
      var φ2 = degrees_to_radians(params.latitude);
      var Δφ = degrees_to_radians(params.latitude-params.center_latitude);
      var Δλ = degrees_to_radians(params.longitude-params.center_longitude);

      var a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

      var d = R * c;

      if(d > params.geofence_radius) {
        params.alert = 1;
      }
      else {
        params.alert = 0;
      }
    }
    else {
      console.log("Required Parameters for Geofence Calculation Not Provided");
      return {error: "Required Parameters for Geofence Calculation Not Provided"}
    }

    return params;
  }

function degrees_to_radians(degrees)
{
  var pi = Math.PI;
  return degrees * (pi/180);
}
