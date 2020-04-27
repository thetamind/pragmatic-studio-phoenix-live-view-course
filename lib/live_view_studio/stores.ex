defmodule LiveViewStudio.Stores do
  def search_by_zip(zip) do
    :timer.sleep(2000)

    list_stores()
    |> Enum.filter(&(&1.zip == zip))
  end

  def search_by_city(city) do
    list_stores()
    |> Enum.filter(&(&1.city == city))
  end

  def list_stores do
    [
      %{
        name: "Downtown Helena",
        street: "312 Montana Avenue",
        phone_number: "406-555-0100",
        city: "Helena, MT",
        zip: "59602",
        open: true,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "East Helena",
        street: "227 Miner's Lane",
        phone_number: "406-555-0120",
        city: "Helena, MT",
        zip: "59602",
        open: false,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Westside Helena",
        street: "734 Lake Loop",
        phone_number: "406-555-0130",
        city: "Helena, MT",
        zip: "59602",
        open: true,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Downtown Denver",
        street: "426 Aspen Loop",
        phone_number: "303-555-0140",
        city: "Denver, CO",
        zip: "80204",
        open: true,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Midtown Denver",
        street: "7 Broncos Parkway",
        phone_number: "720-555-0150",
        city: "Denver, CO",
        zip: "80204",
        open: false,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Denver Stapleton",
        street: "965 Summit Peak",
        phone_number: "303-555-0160",
        city: "Denver, CO",
        zip: "80204",
        open: true,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Denver West",
        street: "501 Mountain Lane",
        phone_number: "720-555-0170",
        city: "Denver, CO",
        zip: "80204",
        open: true,
        hours: "8am - 10pm M-F"
      }
    ]
  end
end
