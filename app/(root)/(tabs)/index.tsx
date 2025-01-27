import { Image, ScrollView, Text, TouchableOpacity, View } from "react-native";
import { Link, Redirect, useRouter } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";
import images from "@/constants/images";
import icons from "@/constants/icons";

export default function Index() {
  const router = useRouter();

  const handleBtnSettings = () => {
    router.push("/sign-in");
  }

  const handleBtnPetProfile = () => {
    router.push("/pet/pet-profile");
  }

  const handleBtnMedicalRecords = () => {
    router.push("/pet/medical-record");
  }

  return (
    // <View
    //   style={{
    //     flex: 1,
    //     justifyContent: "center",
    //     alignItems: "center",
    //   }}
    // >
    //   <Text className="my-10 font-inter-bold text-3xl">Welcome</Text>
    //   <Link href="/sign-in">Sign In</Link>
    //   <Link href="/explore">Explore</Link>
    //   <Link href="/profile">profile</Link>
    //   <Link href="/properties/1">properties</Link>
    // </View>
    <SafeAreaView className="bg-white h-full">
      <ScrollView contentContainerClassName="h-full p-6">
        {/* header */}
        <View>
          <View className="">
            <Text className="font-inter text-lg text-center text-primary-300">
              Hey Shehan, {"\n"} Welcome to Sheeba's Profile
            </Text>
          </View>
        </View>
        <View className="mt-3 flex flex-row items-center justify-center">
          <Image source={images.logoImg} />
        </View>

        {/* body */}
        <View className="mt-3">
          {/* body: navigation */}
          <View className="w-5/6 mx-auto flex flex-row items-center justify-between">
            <TouchableOpacity>
              <View>
                <Image source={icons.add} className="w-8 h-8" />
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={handleBtnSettings}>
              <View>
                <Image source={icons.settings} className="w-8 h-8" />
              </View>
            </TouchableOpacity>
            <TouchableOpacity>
              <View>
                <Image source={icons.sos} className="w-12 h-12" />
              </View>
            </TouchableOpacity>
            <TouchableOpacity>
              <View>
                <Image source={icons.bell} className="w-8 h-8" />
              </View>
            </TouchableOpacity>
            <TouchableOpacity>
              <View>
                <Image source={icons.calendar} className="w-8 h-8" />
              </View>
            </TouchableOpacity>
          </View>

          {/* body: actions */}
          <View className="w-4/5 mx-auto mt-6 flex flex-col gap-4">
            <TouchableOpacity onPress={handleBtnPetProfile} className="px-4 py-3 rounded-lg shadow bg-primary-200">
              <View className="flex flex-row items-center">
                <Image source={icons.user} className="w-10 h-10" />
                <Text className="ps-4 text-lg text-primary-300">Pet Profile</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity onPress={handleBtnMedicalRecords} className="px-4 py-3 rounded-lg shadow bg-primary-200">
              <View className="flex flex-row items-center">
                <Image source={icons.sheets} className="w-10 h-10" />
                <Text className="ps-4 text-lg text-primary-300">Medical Records</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity className="px-4 py-3 rounded-lg shadow bg-primary-200">
              <View className="flex flex-row items-center">
                <Image source={icons.syringe} className="w-10 h-10" />
                <Text className="ps-4 text-lg text-primary-300">Vaccination Records</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity className="px-4 py-3 rounded-lg shadow bg-primary-200">
              <View className="flex flex-row items-center">
                <Image source={icons.search} className="w-10 h-10" />
                <Text className="ps-4 text-lg text-primary-300">Find A Vet</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity className="px-4 py-3 rounded-lg shadow bg-primary-200">
              <View className="flex flex-row items-center">
                <Image source={icons.content} className="w-10 h-10" />
                <Text className="ps-4 text-lg text-primary-300">News Feed</Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
