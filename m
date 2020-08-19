Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47726C433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 14:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1160B2067C
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 14:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="FxHIhTfl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHSOBR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 10:01:17 -0400
Received: from mail-dm6nam11on2123.outbound.protection.outlook.com ([40.107.223.123]:9921
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbgHSOBN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Aug 2020 10:01:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or4jSZaWPAefCmC6N6ZtbUvguVlTGGNtS3DYVWVFQV1O8UHfa50EyCs5Y0I4J4KHR7/r0cr6Ub7m71b1yJCymbgC0joeRNs5n3oldCIX9FBohztwc8Ka2MF1dahTCtueTj1CT1+uBLuAMyiIdKp64gTxFAK9g/jWe+vOVD+5/k5nz8pjgA8R0NGwDWlupK6mjND+lPADnxGo0lhWe1Fvbrf3d/eNdYQgHvrpnUXBbHzaW3C2oXcD6OqZik1/e2ENApvb49mXQnTcj+Kk2ptPUiXlK4TJ2P1i2IjqWBbojW5IUMZcET6ybGegsz0LN0lVAOzB2e2qhJdYllH+VClyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vC2nhcbUlAsGoLz4Mgml1mT+zwBB3gH/lJlmcJfUL8g=;
 b=Y09zfdpcqxnYuCU6WN+xqdmNxMDPsw9F7ztGOd/vCAmwuK/2a8i+06lyh2rd3iBNFyjpigTpCYdficpU/sETW8dl5ldqnSWDky/kcMMbsN/5mfMwKYXUr7LkBy6AC1X+4TOedN53h0kKw6QoFAa+lvTQ+F1cpDai/QPXQ7QH6Lr6yztB7m8UzqovNFRZxY/WcPqC8Kdq+8DP8dAVb5ScG9YIc6Qb0nBqbPdw5i7FsOetO0XN36nCxIIk1VVfbLXljRjcBml81slQEzBb9DPA4IxILhfJQsQFdh6mMFscbrB1Wy9kQmumtksvv+3Vnb/m7eYG2/CZCNFW6DBUkN6WiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vC2nhcbUlAsGoLz4Mgml1mT+zwBB3gH/lJlmcJfUL8g=;
 b=FxHIhTflKNY6rxteD6n5LWX+weiL73cVuJXQ7Xkd5cWCIoJL+4Is5Vh8vHfpkM0Q1dgiU/XBxoULWSIVlA9D68MpV/mYEdczbehAKTeEXsD+AeZTRitxreL03+koKcGl4G2r0fj2V6MlHE9mBvyNN9iGWRqRoBv4cmROPYNV1sw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3302.namprd11.prod.outlook.com (2603:10b6:a03:7b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Wed, 19 Aug
 2020 14:01:08 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 14:01:07 +0000
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com>
 <20200818145234.GC132200@linux.intel.com>
 <20200818150627.GD132200@linux.intel.com>
 <CAOASepNxu0YtSPjXynLaVgyt-S0uSad8HVrNgMNWf+Z7iamPvQ@mail.gmail.com>
 <20200818164353.GH137138@linux.intel.com>
 <CAOASepMABkAxMRY7fJr4bAqadYyVrhZkb0BmB8cTcXUL_VmwQw@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <030542d9-4fb1-15c1-0146-d27bac08024a@fortanix.com>
Date:   Wed, 19 Aug 2020 16:00:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAOASepMABkAxMRY7fJr4bAqadYyVrhZkb0BmB8cTcXUL_VmwQw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090108030804060303050605"
X-ClientProxiedBy: LO2P265CA0284.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::32) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO2P265CA0284.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Wed, 19 Aug 2020 14:01:02 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba64b3cb-b394-4081-1140-08d8444851a3
X-MS-TrafficTypeDiagnostic: BYAPR11MB3302:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3302ABD479C5482BA9CA4CEFAA5D0@BYAPR11MB3302.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JEYw0GtYdNeHtSHVOxJhe9RUcKVnI/SNOl3y0ldsHp9WTIqPN+C5O42cXtqTHYfHIvVx/wTX8fPKC3n0i49WPsgSuE0hLneOvhy+8iXgKyyiJLwp+nkaNXrf4W6U4CbRwjA1Rw3A6/fEEHtjIT6JZQkwVGlijSkliTznJmEctq4flNIYSmMyQzrVtQXHGjSg2yFTvjWVoz7VtMVJ/pHvrdUKKb0/iTOHjF3uPguBVRVCsZe3Lisxt3RxVg2SSjCTbwNyKPUDePCs98Kmf8e6EgW6dVCmOqUDAO0bysWBFWvyTNFVrewXYKvNK6krw2/xjvcBjmOn+u6qelg1N+XCWUbW3ucDdg2sE8TiPfy2KPxQ8VmG241HRNpcJmlR5NU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39840400004)(396003)(366004)(26005)(54906003)(8936002)(316002)(66946007)(66556008)(36756003)(31696002)(66476007)(235185007)(53546011)(6486002)(52116002)(110136005)(5660300002)(186003)(16576012)(8676002)(2906002)(16526019)(4326008)(33964004)(7416002)(31686004)(86362001)(2616005)(956004)(478600001)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cGdAGx1hpXVplBn7VWZiXs4wvMdATIATgA/d/O5ajkcfuYi3IAagpnG/gLYQylX+qTHrMaAOkpGI/hhSh0c/BUyHiH0eXIzVj5fkmXYA+LFmiU5miqCYP2A/rfYWj24haexJViSvSqp0plCrN/re2npCptdz42pyUW60JLvpJtiAyxqe4J6yIrvMspVcP3EccM/1gD4fyxtpN18k9oit3qO5fNQQkdqIJhP7LCDucUBoBbgXHXqo7HOwktnyZ8oo3fvt9PxXWwW6voYt1X9ECgugf97fimapJzWLZS8VhRfRr/31D8ZnvUyHkhMAM1ry7eXEp/NkfFjOo+atsXsQ6V7pDhXEVEUDNo8DlewTdJ6l6TJ/9mc0NphqEj33LZOIsB1svbtbvCbjtigw6wrvVMtbDfSg3t5BxUNJUtAxLlhKpWztc0mTWqqd0HHcVmQ4hUykGDUBtFqqYV9vTXtSdQCTsTZEIAM1yifGd3Wl73eUfH7kCYycAkvUe5vJY2m43sP0eBWWiUnXwuYUSkshMk6ZDzFV9ymAKABiH6wCdx6QUcZpqutr/9LFgqeTumHGPBEkNOj2Ufl1xM0q5CgxgjPZAX3bKSotmkS+KBPsbOLNgyZp7dYMZJ6lZd348U6Bjsfjt3hXlYbnEZKx9rYzVw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba64b3cb-b394-4081-1140-08d8444851a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 14:01:07.6877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5/BCiIh2wmEnL1jYPBo/6ZRDitdaMqfefOvZKKKMhKwPXOgGloU4v8xtK3n+1JVAGV034s6SLBLAFCpexIU3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3302
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090108030804060303050605
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-19 15:33, Nathaniel McCallum wrote:
> On Tue, Aug 18, 2020 at 12:44 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Tue, Aug 18, 2020 at 11:15:32AM -0400, Nathaniel McCallum wrote:
>>> That seems like overkill to me. I'm just asking for one additional mo=
v
>>> instruction. :)
>>
>> I started to consider eBPF since the complexity and constraints of the=

>> callback look like an overkill and without doubt will be a burden to
>> maintain.
>=20
> That feels to me like more complexity just to move the existing
> complexity from one place to another.
>=20

Agreed that BPF doesn't make things better.

--
Jethro Beekman | Fortanix


--------------ms090108030804060303050605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MTkxNDAwNTVaMC8GCSqGSIb3DQEJBDEiBCAVhgPhoXtm
5++lE0s6JZ8YjQOYzLjnyEU59it7GU2p3DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAF5kyGmPh3nfhbA+A6iHsaohlBXk2WZq85u0HiuiT9QmuDT4JPRU/Cfco
XKRegGnLJ3pvoBMeJDBP1Tmo+TDE24KlynadPJa+LG6IgfU9Yga8K/DR70IupTNuuFZsUpjk
p2iaBz5CUt/dKKpEm274+r2e4/tqDcYXN8J+CljsHEsigoi7RZN+JsBpJ3lGYoIqyIZnGmpd
awdcKxekTRZdoz/7IPWlUrPnZWRCpOqkOENSSY3wnBsBbzi5CeTZtcRibcm4kGXfbceVZApv
Bj+t2PEXO5MNUEbwUz6/AMqjiI5ppMHHbq4iBpbHqCdHaDqS0uHSglz2ZMPTuf6BQXI7awAA
AAAAAA==

--------------ms090108030804060303050605--
