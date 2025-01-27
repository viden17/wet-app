import { View, Text, SafeAreaView, ScrollView, Image, TouchableOpacity } from "react-native";
import React from "react";
import icons from "@/constants/icons";
import images from "@/constants/images";

const MedicalRecord = () => {
  return (
    <SafeAreaView className="h-full bg-white">
        <View className="px-3 py-2 bg-primary-100 shadow-sm">
          <TouchableOpacity>
            <Text className="text-xl font-inter-medium text-center">Medical Records</Text>
          </TouchableOpacity>
        </View>
      <ScrollView contentContainerClassName="h-full">
        {/* body: icon */}
        <TouchableOpacity className="px-3 py-6 flex flex-row items-center justify-end">
            <Image source={icons.add} className="w-10 h-10" resizeMode="contain" />
        </TouchableOpacity>

        {/* body: list */}
        <View className="px-3">
            <View className="p-3 rounded">
                <Text className="text-lg font-inter-medium">Type of the Disease</Text>
                <TouchableOpacity className="mt-3 px-3 py-4 flex flex-row items-center justify-between bg-gray-200 shadow-sm rounded">
                    <Text className="text-base font-inter">Parvo Virus</Text>
                    <Image source={icons.btnForwardArrow} className="w-8 h-8" resizeMode="contain" />
                </TouchableOpacity>
                <TouchableOpacity className="mt-3 px-3 py-4 flex flex-row items-center justify-between bg-white shadow-sm rounded">
                    <Text className="text-base font-inter">Canine Parvovirosis</Text>
                    <Image source={icons.btnForwardArrow} className="w-8 h-8" resizeMode="contain" />
                </TouchableOpacity>
                <TouchableOpacity className="mt-3 px-3 py-4 flex flex-row items-center justify-between bg-gray-200 shadow-sm rounded">
                    <Text className="text-base font-inter">Canine Distemper</Text>
                    <Image source={icons.btnForwardArrow} className="w-8 h-8" resizeMode="contain" />
                </TouchableOpacity>
                <TouchableOpacity className="mt-3 px-3 py-4 flex flex-row items-center justify-between bg-white shadow-sm rounded">
                    <Text className="text-base font-inter">Bacteria in the Genus</Text>
                    <Image source={icons.btnForwardArrow} className="w-8 h-8" resizeMode="contain" />
                </TouchableOpacity>
            </View>
        </View>

        {/* body: image */}
        <View className="mt-4 flex flex-row items-center justify-end">
            <Image source={images.medicalRecord} className="w-40 h-40" resizeMode="contain" />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default MedicalRecord;
