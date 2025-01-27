import icons from "@/constants/icons";
import images from "@/constants/images";
import { useRouter } from "expo-router";
import React from "react";
import {
  View,
  Text,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Image,
  ImageBackground,
} from "react-native";

const PetProfile = () => {
  const router = useRouter();

  const descriptionData = [
    {
      title: "Species",
      text: "Dog",
    },
    {
      title: "Breed",
      text: "German Shepard",
    },
    {
      title: "Birth date",
      text: "2023/05/11",
    },
    {
      title: "Weight",
      text: "20Kg",
    },
    {
      title: "Age",
      text: "1y 6m",
    },
    {
      title: "Blood Group",
      text: "DEA 3",
    },
  ];

  const handleBtnMedicalRecords = () => {
    router.push("/pet/medical-record");
  };

  return (
    <SafeAreaView className="h-full bg-white">
      <ImageBackground source={images.bgPetProfile} resizeMode="cover" blurRadius={8}>
        {/* header */}
        {/* <View className="px-3 py-2 bg-primary-100 shadow-sm">
          <TouchableOpacity>
            <Image
              source={icons.btnBack}
              resizeMode="contain"
              className="w-8 h-8 bg-gray rounded-full shadow"
            />
          </TouchableOpacity>
        </View> */}
        <ScrollView contentContainerClassName="h-full p-4 bg-white/50">
          {/* body */}
          <View className="h-full">
            {/* body: details */}
            <View className="h-2/3">
              {/* details: title */}
              <View className="h-1/3 flex flex-row items-center">
                <View className="z-10 rounded-full border">
                  <Image
                    source={images.profilePic}
                    className="w-28 h-28 rounded-full"
                    resizeMode="contain"
                  />
                </View>
                <View className="-ms-3 px-6 py-3 bg-gray-200 rounded-r-xl">
                  <Text className="uppercase">Sheeba</Text>
                </View>
              </View>

              {/* details: description */}
              <View className="h-2/3 w-full flex flex-row flex-wrap">
                {descriptionData &&
                  descriptionData.map((data, index) => (
                    <View className="w-1/2 p-3" key={index}>
                      <Text className="ps-2 text-sm font-inter-light">{data.title}</Text>
                      <View className="mt-1 p-3 bg-gray-200 rounded-lg">
                        <Text>{data.text}</Text>
                      </View>
                    </View>
                  ))}
              </View>
            </View>

            {/* body: actions */}
            <View className="h-1/3 mx-3 pt-4 flex flex-col gap-4">
              <TouchableOpacity
                onPress={handleBtnMedicalRecords}
                className="px-4 py-3 rounded-lg shadow bg-primary-200"
              >
                <View className="flex flex-row items-center">
                  <Image source={icons.sheets} className="w-10 h-10" />
                  <Text className="ps-4 text-lg text-primary-300">Medical Record</Text>
                </View>
              </TouchableOpacity>
              <TouchableOpacity className="px-4 py-3 rounded-lg shadow bg-primary-200">
                <View className="flex flex-row items-center">
                  <Image source={icons.syringe} className="w-10 h-10" />
                  <Text className="ps-4 text-lg text-primary-300">Vaccination Record</Text>
                </View>
              </TouchableOpacity>
            </View>
          </View>
        </ScrollView>
      </ImageBackground>
    </SafeAreaView>
  );
};

export default PetProfile;
