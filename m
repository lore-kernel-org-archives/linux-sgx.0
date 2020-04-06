Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C8BC2BA1B
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 17:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAF2249D9
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 17:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="dtfwarUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgDFRSJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 13:18:09 -0400
Received: from mail-eopbgr690100.outbound.protection.outlook.com ([40.107.69.100]:58761
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbgDFRSJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 13:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItL/OC74wgFARbYMMUCE7QB64dhEpDxclxFMnbEVvOdh1RGLWIMvicFyYUF00Y5gYpcWlxZ/Guk6HfPjJmMN+DMp+0CYpmGcNu/GHlyUR3OR9AixaA7TSHpo+WWkB582Pe4P8I8B9lkqd5CAZzm4OX3XiK5T+jom36BwSVc8h4vTRHchY77DMWzDljIV0wdjQ/0WiJugk1BJ+cIi4hKrQISVggWV3WJVM6WTfn4Ka7/evl76wmKTaBKzmmDpHd6BOnc59q48WMkv3lQTIGDZElJ6BVvZCMOHnRRyDVCYoY/Pbo558N2cVsislhRFPPmFYthHV4LYUNkH5X4/IFP+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyL9Dkq97cNgYgwMEa7UHt3mFcfTzJ//0I1Yszh06c4=;
 b=Z87FYqqykq9k88yUyN8clK206GRmGtU6XChLWbTSaHI4+ocqffRXP4hkpu5D/B2VPuLCVTMyAvenyzaMc8grccr3cTNVWIQn5NzW0K/juC7Rx+lkLa7U5AMhRca/J4EZnw0oARufDdGalCo0mL5Ch+8wjAyArScaqA3EahFJACONUGQoxFLHGPmSYjUrJNunjc3H+ZVcVGdhIcu9lVVmL2pkU7kFnHHOaoHFd9m7CG+yj4n1HRZMl1aIQIJiJ8g7DAdG9YbN5nkgb9LNkmxbp3mIkPeqF5lNETJE4FjRUitimcNLYjvYo0HYKhyLNr8K2xp+oozFnk/qcRX1hqpfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyL9Dkq97cNgYgwMEa7UHt3mFcfTzJ//0I1Yszh06c4=;
 b=dtfwarUQirhOVrK4MohS+sF/v9p7AeQ9WEjcgL0T+EK0I+1kC82EIiLN7/y1vQ4zlH2JRiPIF1WegGNLlxa8dZRxyj0kY2JfSU0cIGbk5Xgz1U2TgH4ZxZTy3e9xyeTlUCWypFgdY55jrqV3hgWn/YkCqt7mmxj6YZyC2QbAMvY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4291.namprd11.prod.outlook.com (2603:10b6:a03:1c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 17:18:05 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a%6]) with mapi id 15.20.2878.017; Mon, 6 Apr 2020
 17:18:05 +0000
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Andy Lutomirski <luto@amacapital.net>,
        Topi Miettinen <toiwoton@gmail.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
 <0F11A8CE-912C-4920-B281-F5AC8C0AFF36@amacapital.net>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <97ab9464-ced7-c709-d58e-2c0a2e63c657@fortanix.com>
Date:   Mon, 6 Apr 2020 19:17:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <0F11A8CE-912C-4920-B281-F5AC8C0AFF36@amacapital.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050102040300070807090908"
X-ClientProxiedBy: AM0P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::29) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:ba78:aa11:920c:d2e1] (2a02:a210:a441:3083:ba78:aa11:920c:d2e1) by AM0P190CA0019.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Mon, 6 Apr 2020 17:18:02 +0000
X-Originating-IP: [2a02:a210:a441:3083:ba78:aa11:920c:d2e1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8035377c-42cb-46ce-b31c-08d7da4e77d3
X-MS-TrafficTypeDiagnostic: BY5PR11MB4291:
X-Microsoft-Antispam-PRVS: <BY5PR11MB42913C015A6E826466202034AAC20@BY5PR11MB4291.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(376002)(396003)(366004)(346002)(39840400004)(31696002)(54906003)(52116002)(33964004)(81156014)(6486002)(110136005)(8676002)(8936002)(4326008)(81166006)(31686004)(36756003)(316002)(86362001)(2616005)(66556008)(66946007)(508600001)(66476007)(53546011)(2906002)(7416002)(6666004)(5660300002)(235185007)(186003)(16526019);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LuTm+7ULi5iqRqY4BK3aI7hmpFoh0L94Ti6WWCLMcnnTNxYwAl6VHee/mLyli1m0Cpqw4l0x0pwqZvmob/r+amDP8u8qUv/FVJgkYpcIw5IvYQdtplvB4W/8b85qNudCiMzNGD+88z/57STSUFaZuSksHLIHKW1chezC+qnZp9X/xtwiBEnGKS97csKUgtkCglsHiLffPydkBQ8tT+HbbdoduCfNAF7e8xEEPHTOPnWfp5ayhPGNNXz/867vbrXODYXenabBEE8rYt0BhvtoZWtrFtjG77BiF3L7wSTLXa0zL+7detwOurQGCtp2RLScMbbngMB1NBXQxiSQL2VRAsrwy5Nxo6N7qRg6bLdRbPkNWhCXT+zhpwBAJp1DeT7HIDbDwX6rVCVd4xT5Os1OeDvzEHdsR9uU4teiiZRYM6NsuaoF/kfKyMkGu0hiZHw
X-MS-Exchange-AntiSpam-MessageData: +dWJTHVxyB4wK+TnR7mamlnxWlbmwoIzsY3HHJMZ9Bzgu9DOi2r/79hrXyq5dSNNhQCMUNBVfMC8KAPbMMmzP1foG4opRkHaEGVFxZvxoB8ExoKKg9MG/b73sxaDRl0c9/NxZvCrPRcssC/RJ7ueToH9XJpSy969zgxUzgUYa311Fv7wM+HxZGKkJGIEa44vrRQIe3NQh6ic51RXwvW2dQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8035377c-42cb-46ce-b31c-08d7da4e77d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 17:18:05.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBJCIpbCwoycQoFm3l0eVT1LF5qnxljefLmHZRXKQPI1fCEi5kuTZj6B+Bv151zdqlB3eLVACFNgUwwytV4Szw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4291
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050102040300070807090908
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-06 18:44, Andy Lutomirski wrote:
>=20
>> On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wrote:=

>>
>> =EF=BB=BFOn 6.4.2020 9.42, Jethro Beekman wrote:
>>> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make=
 a similar exception as with v86d and grant exec to /dev.
>>> I'm not sure this is a reasonable approach. Expect most devices with =
an Intel processor will have the SGX device going forward. Then, no one i=
s using noexec, so why have this logic at all?
>>
>> Intel does not control the whole market yet, does AMD also offer SGX o=
r similar? Will SGX be also available for consumer devices? Are distros g=
oing to enable SGX, will it benefit their users somehow?
>>
>> Perhaps the sgxfs approach or something else (system call?) would be b=
etter after all in order to not force exec just because of one device. /d=
ev is usually writable, so allowing exec means breaking the W^X principle=
 for filesystems.
>>
>>
>=20
> It=E2=80=99s *possible* to create a tmpfs, create the sgx nodes on it, =
bind-mount to /dev/sgx/..., and lazy-unmount the tmpfs.
>=20
> I don=E2=80=99t know whether udev would be willing to support such a th=
ing.
>=20

It doesn't even need to be in a temporary location, you can just mount it=
 directly at /dev/sgx

--
Jethro Beekman | Fortanix


--------------ms050102040300070807090908
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MDYxNzE3NTZaMC8GCSqGSIb3DQEJBDEiBCC9vAYQibGl
OKXcL+9E7jgOV90AbgIqMVbAc5yiS69u/DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAbt+5Yj0TBDwq4itFeZfn9xe7N+gDb2eAQFIbZJ+LB9ze2kqfkx0FGeQm
oI7HDSeGUf69pSecMALJdannnBWCr6cmxo4a4oRNLZLO0vvw/ClS4ZQ409BGkvziDqO7kI33
SdCPjMieLhKTjiV01AM/mQ3cbE+453iBKR8ypjD+GJQFB+ZXad7/6p2XTc63gTLr4vKQGcpq
wGx+sejed+K1dAkp3ze7zavpfBThxoufWC/jX1M9XOi8LVFQuSbhnJxfVv4hOoJJRq1CrR42
yK+lNaLvZHw59MIMfnmjytH7Ta/Czg6mskvIPCtJ31uNFxQK5ueBndxBwrKLtPMtsGRXGQAA
AAAAAA==

--------------ms050102040300070807090908--
