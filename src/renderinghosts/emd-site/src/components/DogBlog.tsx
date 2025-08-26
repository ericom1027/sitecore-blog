import React from 'react';
import { Field, Text } from '@sitecore-jss/sitecore-jss-nextjs';

interface ArticleItem {
  url: string | undefined;
  fields: {
    Title: Field<string>;
  };
}

interface DogBlogProps {
  fields?: {
    Title: Field<string>;
    IntroText: Field<string>;
    LatestPostsTitle: Field<string>;
    ArticleItem: ArticleItem[];
  };
}

const DogBlog = ({ fields }: DogBlogProps) => {
  return (
    <section className="w-full bg-gray-500 px-8 py-12 text-black">
      <div className="max-w-7xl mx-auto flex flex-col gap-12">
        <div className="flex-1 self-start">
          <h2 className="text-md md:text-lg font-bold mb-4">
            <Text field={fields?.Title} />
          </h2>

          <p className="mb-6 max-w-xl">
            <Text field={fields?.IntroText} />
          </p>

          <h3 className="text-md font-semibold mb-2">
            <Text field={fields?.LatestPostsTitle} />
          </h3>

          <ul className="list-disc list-inside flex flex-col gap-2">
            {fields?.ArticleItem?.map((item, index) => (
              <li key={index}>
                <a
                  href={item.url}
                  className="text-black no-underline hover:text-blue-400 transition-colors duration-300"
                >
                  <Text field={item.fields.Title} />
                </a>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </section>
  );
};

export default DogBlog;
