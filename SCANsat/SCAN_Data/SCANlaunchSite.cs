namespace SCANsat.SCAN_Data
{
	public class SCANlaunchSite
	{
		public string Name { get; private set; }
		public double Latitude { get; private set; }
		public double Longitude { get; private set; }

		public SCANlaunchSite(string name, double lat, double lon)
		{
			Name = name;
			Latitude = lat;
			Longitude = lon;
		}
	}
}
