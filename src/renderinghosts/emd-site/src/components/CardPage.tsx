import { Text, RichText, Image, Field, ImageField} from '@sitecore-jss/sitecore-jss-nextjs';

type DogBlogPostProps = {
  fields: {
    breedName: Field<string>;
    image: Field<ImageField>;
    description: Field<string>;
    fullDescription: Field<string>;
  };
};

export default function DogBlogPost({ fields }: DogBlogPostProps) {
  return (
    <article className="max-w-3xl mx-auto p-6 bg-white rounded-2xl shadow-lg">
      <h1 className="flex justify-center items-center text-3xl font-bold mb-4 text-gray-900">
        <Text field={fields.breedName} />
      </h1>

      <div className="flex justify-center items-center my-6">
        <Image
          Field={fields.image}
          className="w-full max-w-md h-auto object-cover rounded-xl shadow-lg"
        />
      </div>

      <p className="mt-2 text-md text-gray-600 italic text-center">
        <Text field={fields.description} />
      </p>

      <div className="prose prose-lg md:prose-lg prose-gray mx-auto leading-relaxed">
        <RichText field={fields.fullDescription} />
      </div>
    </article>
  );
}
