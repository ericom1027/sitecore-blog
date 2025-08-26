import { Field, Text, RichText } from '@sitecore-jss/sitecore-jss-nextjs';
import React from 'react';

type ContactProps = {
  fields: {
    Title: Field<string>;
    Description: Field<string>;
    EmailLabel: Field<string>;
    Email: Field<string>;
    PhoneLabel: Field<string>;
    Phone: Field<string>;
    AddressLabel: Field<string>;
    Address: Field<string>;
  };
};

function Contact({ fields }: ContactProps): JSX.Element {
  return (
    <section className="w-full bg-gradient-to-br from-indigo-50 via-white to-purple-50 text-gray-900 py-20 px-6 md:px-20">
      <div className="max-w-3xl mx-auto text-center mb-16">
        <h2 className="text-3xl md:text-4xl font-extrabold text-indigo-800 tracking-tight mb-4">
          <Text field={fields?.Title} />
        </h2>
        <div className="text-lg md:text-xl text-gray-700 leading-relaxed">
          <RichText field={fields?.Description} />
        </div>
      </div>

      <div className="flex flex-col md:flex-row justify-center items-stretch gap-10 max-w-5xl mx-auto">
        <div className="flex-1 bg-white shadow-xl rounded-3xl p-10 flex flex-col items-center text-center hover:shadow-2xl hover:-translate-y-1 transition-all duration-300 ease-in-out">
          <h3 className="text-xl font-semibold text-gray-800 mb-2">
            <Text field={fields?.EmailLabel} />
          </h3>
          <a
            href={`mailto:${fields?.Email?.value}`}
            className="text-indigo-600 font-medium hover:underline break-words"
          >
            <Text field={fields?.Email} />
          </a>
        </div>

        <div className="flex-1 bg-white shadow-xl rounded-3xl p-10 flex flex-col items-center text-center hover:shadow-2xl hover:-translate-y-1 transition-all duration-300 ease-in-out">
          <h3 className="text-xl font-semibold text-gray-800 mb-2">
            <Text field={fields?.PhoneLabel} />
          </h3>
          <a
            href={`tel:${fields?.Phone?.value}`}
            className="text-green-600 font-medium hover:underline break-words"
          >
            <Text field={fields?.Phone} />
          </a>
        </div>

        <div className="flex-1 bg-white shadow-xl rounded-3xl p-10 flex flex-col items-center text-center hover:shadow-2xl hover:-translate-y-1 transition-all duration-300 ease-in-out">
          <h3 className="text-xl font-semibold text-gray-800 mb-2">
            <Text field={fields?.AddressLabel} />
          </h3>
          <p className="text-gray-700 leading-relaxed break-words">
            <Text field={fields?.Address} />
          </p>
        </div>
      </div>
    </section>
  );
}

export default Contact;
