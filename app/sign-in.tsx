import images from "@/constants/images";
import React from "react";
import { View, Text, ScrollView, Image, TouchableOpacity } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

const SignIn = () => {
  const handleBtnEnglish = () => {
    return null;
  };

  return (
    <SafeAreaView className="bg-white h-full">
      <ScrollView contentContainerClassName="h-full">
        {/* header */}
        <View className="h-1/2 p-8 flex flex-col items-center justify-center">
          <Image source={images.logoImg} resizeMode="contain" />
          <Text className="mt-3 text-3xl font-inter-bold text-primary-300">Animal Care</Text>
          <Text className="mt-3 text-xl font-inter-semibold text-primary-300">
            Welcome to our innovative pet care App!
          </Text>
          <Text className="mt-1 text-base font-inter text-center">
            Elevate your pet's well-being with cutting-edge technologies. Simplify, personalize and
            embrace a new era in animal care with us.
          </Text>
        </View>

        {/* body */}
        <View className="h-1/2 flex flex-col justify-between">
          <View className="flex flex-col items-center">
            <TouchableOpacity
              onPress={handleBtnEnglish}
              className="w-1/2 py-4 flex flex-row items-center justify-center rounded-lg bg-primary-200 shadow shadow-zinc-300"
            >
              <Text className="text-xl font-inter-medium">English</Text>
            </TouchableOpacity>
            <TouchableOpacity className="mt-8 w-1/2 py-4 flex flex-row items-center justify-center rounded-lg bg-primary-200 shadow shadow-zinc-300">
              <Text className="text-xl font-inter-bold">සිංහල</Text>
            </TouchableOpacity>
            <TouchableOpacity className="mt-8 w-1/2 py-4 flex flex-row items-center justify-center rounded-lg bg-primary-200 shadow shadow-zinc-300">
              <Text className="text-xl font-inter-bold">தமிழ்</Text>
            </TouchableOpacity>
          </View>

          <Text className="pb-4 text-center font-inter-light">2024 &copy; Animal Care</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SignIn;
