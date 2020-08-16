defmodule LiveViewStudio.Cities do
  def suggest(""), do: []

  def suggest(prefix) do
    Enum.filter(list_cities(), &has_prefix?(&1, prefix))
  end

  defp has_prefix?(city, prefix) do
    String.starts_with?(String.downcase(city), String.downcase(prefix))
  end

  def list_cities do
    [
      # Naomi's creation
      "Quimser, MB",
      "Abilene, TX",
      "Addison, IL",
      "Akron, OH",
      "Alameda, CA",
      "Albany, OR",
      "Albany, NY",
      "Albany, GA",
      "Albuquerque, NM",
      "Alexandria, LA",
      "Alexandria, VA",
      "Alhambra, CA",
      "Aliso Viejo, CA",
      "Allen, TX",
      "Allentown, PA",
      "Alpharetta, GA",
      "Altamonte Springs, FL",
      "Altoona, PA",
      "Amarillo, TX",
      "Ames, IA",
      "Anaheim, CA",
      "Anchorage, AK",
      "Anderson, IN",
      "Ankeny, IA",
      "Ann Arbor, MI",
      "Annapolis, MD",
      "Antioch, CA",
      "Apache Junction, AZ",
      "Apex, NC",
      "Apopka, FL",
      "Apple Valley, MN",
      "Apple Valley, CA",
      "Appleton, WI",
      "Arcadia, CA",
      "Arlington, TX",
      "Arlington Heights, IL",
      "Arvada, CO",
      "Asheville, NC",
      "Athens-Clarke County, GA",
      "Atlanta, GA",
      "Atlantic City, NJ",
      "Attleboro, MA",
      "Auburn, AL",
      "Auburn, WA",
      "Augusta-Richmond County, GA",
      "Aurora, CO",
      "Aurora, IL",
      "Austin, TX",
      "Aventura, FL",
      "Avondale, AZ",
      "Azusa, CA",
      "Bakersfield, CA",
      "Baldwin Park, CA",
      "Baltimore, MD",
      "Barnstable Town, MA",
      "Bartlett, IL",
      "Bartlett, TN",
      "Baton Rouge, LA",
      "Battle Creek, MI",
      "Bayonne, NJ",
      "Baytown, TX",
      "Beaumont, CA",
      "Beaumont, TX",
      "Beavercreek, OH",
      "Beaverton, OR",
      "Bedford, TX",
      "Bell Gardens, CA",
      "Belleville, IL",
      "Bellevue, WA",
      "Bellevue, NE",
      "Bellflower, CA",
      "Bellingham, WA",
      "Beloit, WI",
      "Bend, OR",
      "Bentonville, AR",
      "Berkeley, CA",
      "Berwyn, IL",
      "Bethlehem, PA",
      "Beverly, MA",
      "Billings, MT",
      "Biloxi, MS",
      "Binghamton, NY",
      "Birmingham, AL",
      "Bismarck, ND",
      "Blacksburg, VA",
      "Blaine, MN",
      "Bloomington, IN",
      "Bloomington, MN",
      "Bloomington, IL",
      "Blue Springs, MO",
      "Boca Raton, FL",
      "Boise City, ID",
      "Bolingbrook, IL",
      "Bonita Springs, FL",
      "Bossier City, LA",
      "Boston, MA",
      "Boulder, CO",
      "Bountiful, UT",
      "Bowie, MD",
      "Bowling Green, KY",
      "Boynton Beach, FL",
      "Bozeman, MT",
      "Bradenton, FL",
      "Brea, CA",
      "Bremerton, WA",
      "Brentwood, CA",
      "Brentwood, TN",
      "Bridgeport, CT",
      "Bristol, CT",
      "Brockton, MA",
      "Broken Arrow, OK",
      "Brookfield, WI",
      "Brookhaven, GA",
      "Brooklyn Park, MN",
      "Broomfield, CO",
      "Brownsville, TX",
      "Bryan, TX",
      "Buckeye, AZ",
      "Buena Park, CA",
      "Buffalo, NY",
      "Buffalo Grove, IL",
      "Bullhead City, AZ",
      "Burbank, CA",
      "Burien, WA",
      "Burleson, TX",
      "Burlington, NC",
      "Burlington, VT",
      "Burnsville, MN",
      "Caldwell, ID",
      "Calexico, CA",
      "Calumet City, IL",
      "Camarillo, CA",
      "Cambridge, MA",
      "Camden, NJ",
      "Campbell, CA",
      "Canton, OH",
      "Cape Coral, FL",
      "Cape Girardeau, MO",
      "Carlsbad, CA",
      "Carmel, IN",
      "Carol Stream, IL",
      "Carpentersville, IL",
      "Carrollton, TX",
      "Carson, CA",
      "Carson City, NV",
      "Cary, NC",
      "Casa Grande, AZ",
      "Casper, WY",
      "Castle Rock, CO",
      "Cathedral City, CA",
      "Cedar Falls, IA",
      "Cedar Hill, TX",
      "Cedar Park, TX",
      "Cedar Rapids, IA",
      "Centennial, CO",
      "Ceres, CA",
      "Cerritos, CA",
      "Champaign, IL",
      "Chandler, AZ",
      "Chapel Hill, NC",
      "Charleston, SC",
      "Charleston, WV",
      "Charlotte, NC",
      "Charlottesville, VA",
      "Chattanooga, TN",
      "Chelsea, MA",
      "Chesapeake, VA",
      "Chesterfield, MO",
      "Cheyenne, WY",
      "Chicago, IL",
      "Chico, CA",
      "Chicopee, MA",
      "Chino, CA",
      "Chino Hills, CA",
      "Chula Vista, CA",
      "Cicero, IL",
      "Cincinnati, OH",
      "Citrus Heights, CA",
      "Clarksville, TN",
      "Clearwater, FL",
      "Cleveland, TN",
      "Cleveland, OH",
      "Cleveland Heights, OH",
      "Clifton, NJ",
      "Clovis, CA",
      "Clovis, NM",
      "Coachella, CA",
      "Coconut Creek, FL",
      "Coeur d'Alene, ID",
      "College Station, TX",
      "Collierville, TN",
      "Colorado Springs, CO",
      "Colton, CA",
      "Columbia, MO",
      "Columbia, SC",
      "Columbus, IN",
      "Columbus, OH",
      "Columbus, GA",
      "Commerce City, CO",
      "Compton, CA",
      "Concord, NH",
      "Concord, NC",
      "Concord, CA",
      "Conroe, TX",
      "Conway, AR",
      "Coon Rapids, MN",
      "Coppell, TX",
      "Coral Gables, FL",
      "Coral Springs, FL",
      "Corona, CA",
      "Corpus Christi, TX",
      "Corvallis, OR",
      "Costa Mesa, CA",
      "Council Bluffs, IA",
      "Covina, CA",
      "Covington, KY",
      "Cranston, RI",
      "Crystal Lake, IL",
      "Culver City, CA",
      "Cupertino, CA",
      "Cutler Bay, FL",
      "Cuyahoga Falls, OH",
      "Cypress, CA",
      "Dallas, TX",
      "Daly City, CA",
      "Danbury, CT",
      "Danville, VA",
      "Danville, CA",
      "Davenport, IA",
      "Davie, FL",
      "Davis, CA",
      "Dayton, OH",
      "Daytona Beach, FL",
      "DeKalb, IL",
      "DeSoto, TX",
      "Dearborn, MI",
      "Dearborn Heights, MI",
      "Decatur, AL",
      "Decatur, IL",
      "Deerfield Beach, FL",
      "Delano, CA",
      "Delray Beach, FL",
      "Deltona, FL",
      "Denton, TX",
      "Denver, CO",
      "Des Moines, IA",
      "Des Plaines, IL",
      "Detroit, MI",
      "Diamond Bar, CA",
      "Doral, FL",
      "Dothan, AL",
      "Dover, DE",
      "Downers Grove, IL",
      "Downey, CA",
      "Draper, UT",
      "Dublin, CA",
      "Dublin, OH",
      "Dubuque, IA",
      "Duluth, MN",
      "Duncanville, TX",
      "Dunwoody, GA",
      "Durham, NC",
      "Eagan, MN",
      "East Lansing, MI",
      "East Orange, NJ",
      "East Providence, RI",
      "Eastvale, CA",
      "Eau Claire, WI",
      "Eden Prairie, MN",
      "Edina, MN",
      "Edinburg, TX",
      "Edmond, OK",
      "Edmonds, WA",
      "El Cajon, CA",
      "El Centro, CA",
      "El Monte, CA",
      "El Paso, TX",
      "Elgin, IL",
      "Elizabeth, NJ",
      "Elk Grove, CA",
      "Elkhart, IN",
      "Elmhurst, IL",
      "Elyria, OH",
      "Encinitas, CA",
      "Enid, OK",
      "Erie, PA",
      "Escondido, CA",
      "Euclid, OH",
      "Eugene, OR",
      "Euless, TX",
      "Evanston, IL",
      "Evansville, IN",
      "Everett, MA",
      "Everett, WA",
      "Fairfield, CA",
      "Fairfield, OH",
      "Fall River, MA",
      "Fargo, ND",
      "Farmington, NM",
      "Farmington Hills, MI",
      "Fayetteville, NC",
      "Fayetteville, AR",
      "Federal Way, WA",
      "Findlay, OH",
      "Fishers, IN",
      "Fitchburg, MA",
      "Flagstaff, AZ",
      "Flint, MI",
      "Florence, AL",
      "Florence, SC",
      "Florissant, MO",
      "Flower Mound, TX",
      "Folsom, CA",
      "Fond du Lac, WI",
      "Fontana, CA",
      "Fort Collins, CO",
      "Fort Lauderdale, FL",
      "Fort Myers, FL",
      "Fort Pierce, FL",
      "Fort Smith, AR",
      "Fort Wayne, IN",
      "Fort Worth, TX",
      "Fountain Valley, CA",
      "Franklin, TN",
      "Frederick, MD",
      "Freeport, NY",
      "Fremont, CA",
      "Fresno, CA",
      "Friendswood, TX",
      "Frisco, TX",
      "Fullerton, CA",
      "Gainesville, FL",
      "Gaithersburg, MD",
      "Galveston, TX",
      "Garden Grove, CA",
      "Gardena, CA",
      "Garland, TX",
      "Gary, IN",
      "Gastonia, NC",
      "Georgetown, TX",
      "Germantown, TN",
      "Gilbert, AZ",
      "Gilroy, CA",
      "Glendale, CA",
      "Glendale, AZ",
      "Glendora, CA",
      "Glenview, IL",
      "Goodyear, AZ",
      "Goose Creek, SC",
      "Grand Forks, ND",
      "Grand Island, NE",
      "Grand Junction, CO",
      "Grand Prairie, TX",
      "Grand Rapids, MI",
      "Grapevine, TX",
      "Great Falls, MT",
      "Greeley, CO",
      "Green Bay, WI",
      "Greenacres, FL",
      "Greenfield, WI",
      "Greensboro, NC",
      "Greenville, SC",
      "Greenville, NC",
      "Greenwood, IN",
      "Gresham, OR",
      "Grove City, OH",
      "Gulfport, MS",
      "Hackensack, NJ",
      "Hagerstown, MD",
      "Hallandale Beach, FL",
      "Haltom City, TX",
      "Hamilton, OH",
      "Hammond, IN",
      "Hampton, VA",
      "Hanford, CA",
      "Hanover Park, IL",
      "Harlingen, TX",
      "Harrisburg, PA",
      "Harrisonburg, VA",
      "Hartford, CT",
      "Hattiesburg, MS",
      "Haverhill, MA",
      "Hawthorne, CA",
      "Hayward, CA",
      "Helena, MT",
      "Hemet, CA",
      "Hempstead, NY",
      "Henderson, NV",
      "Hendersonville, TN",
      "Hesperia, CA",
      "Hialeah, FL",
      "Hickory, NC",
      "High Point, NC",
      "Highland, CA",
      "Hillsboro, OR",
      "Hilton Head Island, SC",
      "Hoboken, NJ",
      "Hoffman Estates, IL",
      "Hollywood, FL",
      "Holyoke, MA",
      "Homestead, FL",
      "Honolulu, HI",
      "Hoover, AL",
      "Houston, TX",
      "Huber Heights, OH",
      "Huntersville, NC",
      "Huntington, WV",
      "Huntington Beach, CA",
      "Huntington Park, CA",
      "Huntsville, TX",
      "Huntsville, AL",
      "Hurst, TX",
      "Hutchinson, KS",
      "Idaho Falls, ID",
      "Independence, MO",
      "Indianapolis, IN",
      "Indio, CA",
      "Inglewood, CA",
      "Iowa City, IA",
      "Irvine, CA",
      "Irving, TX",
      "Jackson, TN",
      "Jackson, MS",
      "Jacksonville, FL",
      "Jacksonville, NC",
      "Janesville, WI",
      "Jefferson City, MO",
      "Jeffersonville, IN",
      "Jersey City, NJ",
      "Johns Creek, GA",
      "Johnson City, TN",
      "Joliet, IL",
      "Jonesboro, AR",
      "Joplin, MO",
      "Jupiter, FL",
      "Jurupa Valley, CA",
      "Kalamazoo, MI",
      "Kannapolis, NC",
      "Kansas City, MO",
      "Kansas City, KS",
      "Kearny, NJ",
      "Keizer, OR",
      "Keller, TX",
      "Kenner, LA",
      "Kennewick, WA",
      "Kenosha, WI",
      "Kent, WA",
      "Kentwood, MI",
      "Kettering, OH",
      "Killeen, TX",
      "Kingsport, TN",
      "Kirkland, WA",
      "Kissimmee, FL",
      "Knoxville, TN",
      "Kokomo, IN",
      "La Crosse, WI",
      "La Habra, CA",
      "La Mesa, CA",
      "La Mirada, CA",
      "La Puente, CA",
      "La Quinta, CA",
      "Lacey, WA",
      "Lafayette, LA",
      "Lafayette, IN",
      "Laguna Niguel, CA",
      "Lake Charles, LA",
      "Lake Elsinore, CA",
      "Lake Forest, CA",
      "Lake Havasu City, AZ",
      "Lake Oswego, OR",
      "Lakeland, FL",
      "Lakeville, MN",
      "Lakewood, OH",
      "Lakewood, CO",
      "Lakewood, WA",
      "Lakewood, CA",
      "Lancaster, CA",
      "Lancaster, PA",
      "Lancaster, TX",
      "Lancaster, OH",
      "Lansing, MI",
      "Laredo, TX",
      "Largo, FL",
      "Las Cruces, NM",
      "Las Vegas, NV",
      "Lauderhill, FL",
      "Lawrence, KS",
      "Lawrence, IN",
      "Lawrence, MA",
      "Lawton, OK",
      "Layton, UT",
      "League City, TX",
      "Lee's Summit, MO",
      "Leesburg, VA",
      "Lehi, UT",
      "Lenexa, KS",
      "Leominster, MA",
      "Lewisville, TX",
      "Lexington-Fayette, KY",
      "Lima, OH",
      "Lincoln, CA",
      "Lincoln, NE",
      "Lincoln Park, MI",
      "Linden, NJ",
      "Little Rock, AR",
      "Littleton, CO",
      "Livermore, CA",
      "Livonia, MI",
      "Lodi, CA",
      "Logan, UT",
      "Lombard, IL",
      "Lompoc, CA",
      "Long Beach, CA",
      "Longmont, CO",
      "Longview, TX",
      "Lorain, OH",
      "Los Angeles, CA",
      "Louisville/Jefferson County, KY",
      "Loveland, CO",
      "Lowell, MA",
      "Lubbock, TX",
      "Lynchburg, VA",
      "Lynn, MA",
      "Lynwood, CA",
      "Macon, GA",
      "Madera, CA",
      "Madison, AL",
      "Madison, WI",
      "Malden, MA",
      "Manassas, VA",
      "Manchester, NH",
      "Manhattan, KS",
      "Mankato, MN",
      "Mansfield, TX",
      "Mansfield, OH",
      "Manteca, CA",
      "Maple Grove, MN",
      "Maplewood, MN",
      "Marana, AZ",
      "Margate, FL",
      "Maricopa, AZ",
      "Marietta, GA",
      "Marlborough, MA",
      "Martinez, CA",
      "Marysville, WA",
      "McAllen, TX",
      "McKinney, TX",
      "Medford, OR",
      "Medford, MA",
      "Melbourne, FL",
      "Memphis, TN",
      "Menifee, CA",
      "Mentor, OH",
      "Merced, CA",
      "Meriden, CT",
      "Meridian, MS",
      "Meridian, ID",
      "Mesa, AZ",
      "Mesquite, TX",
      "Methuen, MA",
      "Miami, FL",
      "Miami Beach, FL",
      "Miami Gardens, FL",
      "Middletown, OH",
      "Middletown, CT",
      "Midland, MI",
      "Midland, TX",
      "Midwest City, OK",
      "Milford, CT",
      "Milpitas, CA",
      "Milwaukee, WI",
      "Minneapolis, MN",
      "Minnetonka, MN",
      "Minot, ND",
      "Miramar, FL",
      "Mishawaka, IN",
      "Mission, TX",
      "Mission Viejo, CA",
      "Missoula, MT",
      "Missouri City, TX",
      "Mobile, AL",
      "Modesto, CA",
      "Moline, IL",
      "Monroe, LA",
      "Monrovia, CA",
      "Montclair, CA",
      "Montebello, CA",
      "Monterey Park, CA",
      "Montgomery, AL",
      "Moore, OK",
      "Moorhead, MN",
      "Moreno Valley, CA",
      "Morgan Hill, CA",
      "Mount Pleasant, SC",
      "Mount Prospect, IL",
      "Mount Vernon, NY",
      "Mountain View, CA",
      "Muncie, IN",
      "Murfreesboro, TN",
      "Murray, UT",
      "Murrieta, CA",
      "Muskegon, MI",
      "Muskogee, OK",
      "Nampa, ID",
      "Napa, CA",
      "Naperville, IL",
      "Nashua, NH",
      "Nashville-Davidson, TN",
      "National City, CA",
      "New Bedford, MA",
      "New Berlin, WI",
      "New Braunfels, TX",
      "New Britain, CT",
      "New Brunswick, NJ",
      "New Haven, CT",
      "New Orleans, LA",
      "New Rochelle, NY",
      "New York, NY",
      "Newark, CA",
      "Newark, NJ",
      "Newark, OH",
      "Newport Beach, CA",
      "Newport News, VA",
      "Newton, MA",
      "Niagara Falls, NY",
      "Noblesville, IN",
      "Norfolk, VA",
      "Normal, IL",
      "Norman, OK",
      "North Charleston, SC",
      "North Las Vegas, NV",
      "North Lauderdale, FL",
      "North Little Rock, AR",
      "North Miami, FL",
      "North Miami Beach, FL",
      "North Port, FL",
      "North Richland Hills, TX",
      "Northglenn, CO",
      "Norwalk, CA",
      "Norwalk, CT",
      "Norwich, CT",
      "Novato, CA",
      "Novi, MI",
      "O'Fallon, MO",
      "Oak Lawn, IL",
      "Oak Park, IL",
      "Oakland, CA",
      "Oakland Park, FL",
      "Oakley, CA",
      "Ocala, FL",
      "Oceanside, CA",
      "Ocoee, FL",
      "Odessa, TX",
      "Ogden, UT",
      "Oklahoma City, OK",
      "Olathe, KS",
      "Olympia, WA",
      "Omaha, NE",
      "Ontario, CA",
      "Orange, CA",
      "Orem, UT",
      "Orland Park, IL",
      "Orlando, FL",
      "Ormond Beach, FL",
      "Oro Valley, AZ",
      "Oshkosh, WI",
      "Overland Park, KS",
      "Owensboro, KY",
      "Oxnard, CA",
      "Pacifica, CA",
      "Palatine, IL",
      "Palm Bay, FL",
      "Palm Beach Gardens, FL",
      "Palm Coast, FL",
      "Palm Desert, CA",
      "Palm Springs, CA",
      "Palmdale, CA",
      "Palo Alto, CA",
      "Panama City, FL",
      "Paramount, CA",
      "Park Ridge, IL",
      "Parker, CO",
      "Parma, OH",
      "Pasadena, CA",
      "Pasadena, TX",
      "Pasco, WA",
      "Passaic, NJ",
      "Paterson, NJ",
      "Pawtucket, RI",
      "Peabody, MA",
      "Peachtree Corners, GA",
      "Pearland, TX",
      "Pembroke Pines, FL",
      "Pensacola, FL",
      "Peoria, AZ",
      "Peoria, IL",
      "Perris, CA",
      "Perth Amboy, NJ",
      "Petaluma, CA",
      "Pflugerville, TX",
      "Pharr, TX",
      "Phenix City, AL",
      "Philadelphia, PA",
      "Phoenix, AZ",
      "Pico Rivera, CA",
      "Pine Bluff, AR",
      "Pinellas Park, FL",
      "Pittsburg, CA",
      "Pittsburgh, PA",
      "Pittsfield, MA",
      "Placentia, CA",
      "Plainfield, IL",
      "Plainfield, NJ",
      "Plano, TX",
      "Plantation, FL",
      "Pleasanton, CA",
      "Plymouth, MN",
      "Pocatello, ID",
      "Pomona, CA",
      "Pompano Beach, FL",
      "Pontiac, MI",
      "Port Arthur, TX",
      "Port Orange, FL",
      "Port St. Lucie, FL",
      "Portage, MI",
      "Porterville, CA",
      "Portland, OR",
      "Portland, ME",
      "Portsmouth, VA",
      "Poway, CA",
      "Prescott, AZ",
      "Prescott Valley, AZ",
      "Providence, RI",
      "Provo, UT",
      "Pueblo, CO",
      "Puyallup, WA",
      "Quincy, IL",
      "Quincy, MA",
      "Racine, WI",
      "Raleigh, NC",
      "Rancho Cordova, CA",
      "Rancho Cucamonga, CA",
      "Rancho Palos Verdes, CA",
      "Rancho Santa Margarita, CA",
      "Rapid City, SD",
      "Reading, PA",
      "Redding, CA",
      "Redlands, CA",
      "Redmond, WA",
      "Redondo Beach, CA",
      "Redwood City, CA",
      "Reno, NV",
      "Renton, WA",
      "Revere, MA",
      "Rialto, CA",
      "Richardson, TX",
      "Richland, WA",
      "Richmond, CA",
      "Richmond, VA",
      "Rio Rancho, NM",
      "Riverside, CA",
      "Riverton, UT",
      "Roanoke, VA",
      "Rochester, MN",
      "Rochester, NY",
      "Rochester Hills, MI",
      "Rock Hill, SC",
      "Rock Island, IL",
      "Rockford, IL",
      "Rocklin, CA",
      "Rockville, MD",
      "Rockwall, TX",
      "Rocky Mount, NC",
      "Rogers, AR",
      "Rohnert Park, CA",
      "Romeoville, IL",
      "Rosemead, CA",
      "Roseville, CA",
      "Roseville, MI",
      "Roswell, NM",
      "Roswell, GA",
      "Round Rock, TX",
      "Rowlett, TX",
      "Roy, UT",
      "Royal Oak, MI",
      "Sacramento, CA",
      "Saginaw, MI",
      "Salem, OR",
      "Salem, MA",
      "Salina, KS",
      "Salinas, CA",
      "Salt Lake City, UT",
      "Sammamish, WA",
      "San Angelo, TX",
      "San Antonio, TX",
      "San Bernardino, CA",
      "San Bruno, CA",
      "San Buenaventura (Ventura), CA",
      "San Clemente, CA",
      "San Diego, CA",
      "San Francisco, CA",
      "San Gabriel, CA",
      "San Jacinto, CA",
      "San Jose, CA",
      "San Leandro, CA",
      "San Luis Obispo, CA",
      "San Marcos, CA",
      "San Marcos, TX",
      "San Mateo, CA",
      "San Rafael, CA",
      "San Ramon, CA",
      "Sandy, UT",
      "Sandy Springs, GA",
      "Sanford, FL",
      "Santa Ana, CA",
      "Santa Barbara, CA",
      "Santa Clara, CA",
      "Santa Clarita, CA",
      "Santa Cruz, CA",
      "Santa Fe, NM",
      "Santa Maria, CA",
      "Santa Monica, CA",
      "Santa Rosa, CA",
      "Santee, CA",
      "Sarasota, FL",
      "Savannah, GA",
      "Sayreville, NJ",
      "Schaumburg, IL",
      "Schenectady, NY",
      "Scottsdale, AZ",
      "Scranton, PA",
      "Seattle, WA",
      "Shakopee, MN",
      "Shawnee, KS",
      "Sheboygan, WI",
      "Shelton, CT",
      "Sherman, TX",
      "Shoreline, WA",
      "Shreveport, LA",
      "Sierra Vista, AZ",
      "Simi Valley, CA",
      "Sioux City, IA",
      "Sioux Falls, SD",
      "Skokie, IL",
      "Smyrna, TN",
      "Smyrna, GA",
      "Somerville, MA",
      "South Bend, IN",
      "South Gate, CA",
      "South Jordan, UT",
      "South San Francisco, CA",
      "Southaven, MS",
      "Southfield, MI",
      "Spanish Fork, UT",
      "Sparks, NV",
      "Spartanburg, SC",
      "Spokane, WA",
      "Spokane Valley, WA",
      "Springdale, AR",
      "Springfield, OH",
      "Springfield, OR",
      "Springfield, IL",
      "Springfield, MA",
      "Springfield, MO",
      "St. Charles, MO",
      "St. Clair Shores, MI",
      "St. Cloud, FL",
      "St. Cloud, MN",
      "St. George, UT",
      "St. Joseph, MO",
      "St. Louis, MO",
      "St. Louis Park, MN",
      "St. Paul, MN",
      "St. Peters, MO",
      "St. Petersburg, FL",
      "Stamford, CT",
      "Stanton, CA",
      "State College, PA",
      "Sterling Heights, MI",
      "Stillwater, OK",
      "Stockton, CA",
      "Streamwood, IL",
      "Strongsville, OH",
      "Suffolk, VA",
      "Sugar Land, TX",
      "Summerville, SC",
      "Sumter, SC",
      "Sunnyvale, CA",
      "Sunrise, FL",
      "Surprise, AZ",
      "Syracuse, NY",
      "Tacoma, WA",
      "Tallahassee, FL",
      "Tamarac, FL",
      "Tampa, FL",
      "Taunton, MA",
      "Taylor, MI",
      "Taylorsville, UT",
      "Temecula, CA",
      "Tempe, AZ",
      "Temple, TX",
      "Terre Haute, IN",
      "Texarkana, TX",
      "Texas City, TX",
      "The Colony, TX",
      "Thornton, CO",
      "Thousand Oaks, CA",
      "Tigard, OR",
      "Tinley Park, IL",
      "Titusville, FL",
      "Toledo, OH",
      "Topeka, KS",
      "Torrance, CA",
      "Tracy, CA",
      "Trenton, NJ",
      "Troy, NY",
      "Troy, MI",
      "Tucson, AZ",
      "Tulare, CA",
      "Tulsa, OK",
      "Turlock, CA",
      "Tuscaloosa, AL",
      "Tustin, CA",
      "Twin Falls, ID",
      "Tyler, TX",
      "Union City, CA",
      "Union City, NJ",
      "Upland, CA",
      "Urbana, IL",
      "Urbandale, IA",
      "Utica, NY",
      "Vacaville, CA",
      "Valdosta, GA",
      "Vallejo, CA",
      "Valley Stream, NY",
      "Vancouver, WA",
      "Victoria, TX",
      "Victorville, CA",
      "Vineland, NJ",
      "Virginia Beach, VA",
      "Visalia, CA",
      "Vista, CA",
      "Waco, TX",
      "Walnut Creek, CA",
      "Waltham, MA",
      "Warner Robins, GA",
      "Warren, OH",
      "Warren, MI",
      "Warwick, RI",
      "Washington, DC",
      "Waterbury, CT",
      "Waterloo, IA",
      "Watsonville, CA",
      "Waukegan, IL",
      "Waukesha, WI",
      "Wausau, WI",
      "Wauwatosa, WI",
      "Wellington, FL",
      "Weslaco, TX",
      "West Allis, WI",
      "West Covina, CA",
      "West Des Moines, IA",
      "West Haven, CT",
      "West Jordan, UT",
      "West New York, NJ",
      "West Palm Beach, FL",
      "West Sacramento, CA",
      "West Valley City, UT",
      "Westerville, OH",
      "Westfield, MA",
      "Westland, MI",
      "Westminster, CO",
      "Westminster, CA",
      "Weston, FL",
      "Weymouth Town, MA",
      "Wheaton, IL",
      "Wheeling, IL",
      "White Plains, NY",
      "Whittier, CA",
      "Wichita, KS",
      "Wichita Falls, TX",
      "Wilkes-Barre, PA",
      "Wilmington, DE",
      "Wilmington, NC",
      "Wilson, NC",
      "Winston-Salem, NC",
      "Winter Garden, FL",
      "Woburn, MA",
      "Woodbury, MN",
      "Woodland, CA",
      "Woonsocket, RI",
      "Worcester, MA",
      "Wylie, TX",
      "Wyoming, MI",
      "Yakima, WA",
      "Yonkers, NY",
      "Yorba Linda, CA",
      "York, PA",
      "Youngstown, OH",
      "Yuba City, CA",
      "Yucaipa, CA",
      "Yuma, AZ"
    ]
  end
end
