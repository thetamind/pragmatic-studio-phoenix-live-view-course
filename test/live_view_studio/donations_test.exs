defmodule LiveViewStudio.DonationsTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.Donations

  describe "donations" do
    alias LiveViewStudio.Donations.Donation

    @valid_attrs %{days_until_expires: 42, emoji: "some emoji", item: "some item", quantity: 42}
    @update_attrs %{days_until_expires: 43, emoji: "some updated emoji", item: "some updated item", quantity: 43}
    @invalid_attrs %{days_until_expires: nil, emoji: nil, item: nil, quantity: nil}

    def donation_fixture(attrs \\ %{}) do
      {:ok, donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Donations.create_donation()

      donation
    end

    test "list_donations/0 returns all donations" do
      donation = donation_fixture()
      assert Donations.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id" do
      donation = donation_fixture()
      assert Donations.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation" do
      assert {:ok, %Donation{} = donation} = Donations.create_donation(@valid_attrs)
      assert donation.days_until_expires == 42
      assert donation.emoji == "some emoji"
      assert donation.item == "some item"
      assert donation.quantity == 42
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Donations.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{} = donation} = Donations.update_donation(donation, @update_attrs)
      assert donation.days_until_expires == 43
      assert donation.emoji == "some updated emoji"
      assert donation.item == "some updated item"
      assert donation.quantity == 43
    end

    test "update_donation/2 with invalid data returns error changeset" do
      donation = donation_fixture()
      assert {:error, %Ecto.Changeset{}} = Donations.update_donation(donation, @invalid_attrs)
      assert donation == Donations.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{}} = Donations.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Donations.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset" do
      donation = donation_fixture()
      assert %Ecto.Changeset{} = Donations.change_donation(donation)
    end
  end
end
