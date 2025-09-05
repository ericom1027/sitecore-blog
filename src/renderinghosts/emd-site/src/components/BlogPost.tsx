import { Text, RichText, Image, Field, ImageField } from '@sitecore-jss/sitecore-jss-nextjs';

type BlogPostProps = {
  fields: {
    title: Field<string>;
    excerpt: Field<string>;
    content: Field<string>;
    image: Field<ImageField>;
    author: Field<string>;
    date: Field<string>;
  };
};

export default function BlogPost({ fields }: BlogPostProps) {
  return (
    <article className="max-w-3xl mx-auto p-6 bg-white rounded-2xl shadow-lg">
      <h1 className="flex justify-center items-center text-3xl font-bold mb-4 text-gray-900">
        <Text field={fields.title} />
      </h1>

      <div className="flex justify-center items-center my-6">
        <Image
          Field={fields.image}
          className="w-full max-w-md h-auto object-cover rounded-xl shadow-lg"
        />
      </div>

      <p className="text-sm flex justify-center items-center text-gray-500 mb-4">
        <Text field={fields.author} /> | <Text field={fields.date} />
      </p>

      <p className="text-lg text-gray-700 mb-6">
        <Text field={fields.excerpt} />
      </p>

      <div className="prose prose-lg text-gray-800">
        <RichText field={fields.content} />
      </div>
    </article>
  );
}
