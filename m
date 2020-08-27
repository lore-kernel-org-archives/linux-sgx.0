Return-Path: <SRS0=BSu2=CF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5863C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 08:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D202177B
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 08:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="B+oI6H4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0I66 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:58:58 -0400
Received: from mail-bn8nam11on2095.outbound.protection.outlook.com ([40.107.236.95]:57697
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgH0I65 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Aug 2020 04:58:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYO5wmbcRpxi/QtBt9M/sVQ6j8uJKyTt8UOBHmLC7IlvGi9HmNo6GaH2jJAGJF7WQ8CbzLZV/s3gPKm1Z7Z1LTjY6mVD5K2BIfEn5pJ1mfEp8FsAqX+E6s3fQ4WdWNuFSXRixzKETHACYppd3iwkRQAxj6urRwzo2KZebDljDMoniYzJONV5DE0ZKSOf9p0nB0f6MdOuZV/5vcFgMQjK/Ij2cw3wkma4RPsRIZMl/PRAoNQWoavJgqPCS5I76daJXcixGqm4XKjrzaTE7VVAJgtkbK6vwcnu1vwGMN9Ttsay0mNpgAh0Ey6kPv1twmq/pJLlTmiY3iW3cU1TSjG6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYG547mFMAuyvV71RYLSPeI/wbaMthxogZiIST0jKWI=;
 b=Y3bcH8jFVM99F9oSDfixBDC0DGGxYfJCdpP2k/mbeN4mTw2xaxHsieF9MAbbPlfdnvm0YjKRqx8DPPTPEC409UKKg6lAP8QQieJIr23IXx6oRsCEvd1opb6SNSE1BgtwJaTfdSJH9gpyS785MH6dySNRhQIP1LAJxZmOTUEcDxwncKWYdjGvOncmZTJy186fotx4SqLkMucsp/Jiu1wgsX62EdR5nVgZJyTPc0vCR/HXYYzb2Eqfu/ZOy97S5ppSqGYxY5uzhe/2KgXEJEHCAJYvugMd8hVWw7QFLhvFXpEZyPKRhatbAJ0k+Rzjj+IVtN9CHOiQantfQtZpMiUj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYG547mFMAuyvV71RYLSPeI/wbaMthxogZiIST0jKWI=;
 b=B+oI6H4rW1BnBeKd4xXUJbuRNnej2eRa9zAwa4KRy7y0BH3+hwkDDMnumETOTzm9klfpogC/Pivd62jslZWBDxMy+hi855WRZyji95fvm6e+zbdS7DmozAmxMVOVn3q0z9PjeV0Rk3ruDWND2+cMyZT1ZBZwsydzRRhTMGIB4C8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3559.namprd11.prod.outlook.com (2603:10b6:a03:f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 08:58:54 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 08:58:54 +0000
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
 <20200826201511.GB21459@sjchrist-ice>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <18cacc82-af81-d00a-0542-d859bb116f5b@fortanix.com>
Date:   Thu, 27 Aug 2020 10:58:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200826201511.GB21459@sjchrist-ice>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070507000502000404020305"
X-ClientProxiedBy: AM4PR07CA0032.eurprd07.prod.outlook.com
 (2603:10a6:205:1::45) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM4PR07CA0032.eurprd07.prod.outlook.com (2603:10a6:205:1::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 27 Aug 2020 08:58:52 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dccf23be-b372-4c8c-2a19-08d84a676cbf
X-MS-TrafficTypeDiagnostic: BYAPR11MB3559:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3559D4BB882A77828C005767AA550@BYAPR11MB3559.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pqgykOl2FSkba0/mgg0b/+UeQvnqMqiGSSnChVGc1Xx89AgImedJL+rKtGlM56JTd2MDnzz69fqRZIWrAD1gSf5sF4V4MNvEvErcj1saa0s4es8VX0rMPpYjEr42/tWdInRrN4TbFPboKvt4ECkustCufWg4+bQw/6cxGSbREO/CEDFEM+Rw1nmQZc8qsefEr9pgnSfO1tEjDx9JXs0NEDECFqtOAIiljqS2xsYpUx2n8sGyGt9T8eMEGzwCz+DjDLaKZZKRig3pADWS1cGqotQqoFXlJjXWrlAJbrLlWog8VJLo5j+ApKvQeeBxdte+1UYLta+ddbRn5J7/cZqK5dI3Ah7OYUlu5ZiJroiWx5NqGCoanxIzbfk2C7obk23EuL1z407Cyy9xulvvh0cLFoKg4Y5bg6AtFj/i5EISGH0hOJZBUidgtyHfFG9OQMFYMJ8iZKYF+m0oGWNCxOG7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39840400004)(136003)(346002)(376002)(2906002)(110136005)(6666004)(86362001)(8936002)(16576012)(235185007)(36756003)(316002)(2616005)(956004)(31686004)(31696002)(53546011)(33964004)(52116002)(83380400001)(8676002)(5660300002)(966005)(26005)(66476007)(478600001)(186003)(4326008)(66946007)(6486002)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xuXGdGzmaiFDWJCiOk33Mk8Y1voES0iQBtz+I9GDtqwpK1Uw4UON0fEbdI4CP5/9M67/Tz3vhvbOYuIC886kB52fHhhVfx+DjrTjmjW0DaSaTpDduR77vwtAmKJ5oK6mVeiWiw3vM2lQICy7+CaVaJrXz626VTtNIkD4qCm5IlZnRif9yX2FuJANAMWPsv4Iq77Rbd2LVB9K/qYcPF3yCptaGRmMNFoJRTse2pygsuLE7QXfBZnOa39+MtgUzhjanf71q0qcRkTrUqG/KlqIIft12EOWYx5OSKlENw30bFGjcPo/d160hZIXhPL2A9wE0H7vjC4fgyweqaVQNRoFBaFruM/dQUoiIIBAdwqjsP8POfMxzhvn13Hm/8sqWg843jRltyRQWJsIyNQQ/GCTGKpY751Owt940mBTanZeXs9RObW7HQXSq3KBB2h/nGydnF8YVdprQO0fbdeB270CTVty/6DxChAd5XUEiwH8TuSk6xzNxLBhbPLnfCsxO76FhVWum/AqSeOnPtViiqSHZbU6hAAApHPHPKcissfwTrjamoaZhGBhFdOkVdx1ZxT0Ur1ubcQRv8xm5sIumbh81T7JggE1mV7atb7+VwDJQZ782dL7HUQu+HEUeUIwq2Sdw2vBsqS9Q01xIVyNfoxjcA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccf23be-b372-4c8c-2a19-08d84a676cbf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 08:58:54.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k65nURWHMb+xUUsIVuvt8/9MKS0CuZl/qG03AC2aRbeMWys+OvromEJFJj3SmggfaViDu86kTruPBNeuJHmUsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3559
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070507000502000404020305
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-26 22:15, Sean Christopherson wrote:
> On Wed, Aug 26, 2020 at 12:27:54PM -0700, Xing, Cedric wrote:
>> On 8/17/2020 9:24 PM, Sean Christopherson wrote:
>>> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input a=
nd
>>> output params.  In the new struct, add an opaque "user_data" that can=
 be
>>> used to pass context across the vDSO, and an explicit "exit_reason" t=
o
>>> avoid overloading the return value.
>>> In order to pass additional parameters to the exit handler, the exinf=
o
>> structure could be embedded in a user-defined structure while the hand=
ler
>> could pick it up using "container_of" macro. IMO the original interfac=
e was
>> neat and suffcient, and we are over-engineering it.
>=20
> container_of/offsetof shenanigans were my original suggestion as well.
> Nathaniel's argument is that using such tricks is less than pleasent in=
 a
> Rust environment.
>=20
> https://lkml.kernel.org/r/CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjW=
AkpRWw@mail.gmail.com

Just for the record I'm a Rust user and I have nothing against a solution=
 that requires computing field offsets. As others have mentioned, assembl=
y doesn't have facilities for this but it hasn't been a problem there.

--
Jethro Beekman | Fortanix


--------------ms070507000502000404020305
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjcwODU4NDdaMC8GCSqGSIb3DQEJBDEiBCBEqSc7jMLI
6S4LqcEVZVJozZpf8tW14/rPrsd9vWJ3szBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAH5DmvzXUmH8dvFMt1aNFoKKclQh2zGUb7lyI/hLbqcj6CahWDemY0Q2x
PPEkCt+NuP3eiBrhmzsIRfZtKs2KvJ4sNcjA3wq0Oyzq1KB+SiStv6vPMTiEPfGsGd6Zx3zQ
9Zt214aUA0OriaXv671ckQWXUVkr6yHoT5ldQ9pEb6iyb8rGcCvkJ8zb5VA33njgnLSOQ8G1
AKMQzfQ7zcjm6AB4rjbS6PGEAcx/Fe4SUS+Uos/5S4qK1Z6BLl55rNO3zP7ZMWiENUCas3RM
xABqSZ60SJEUc+0Q1dIip1DrK8pc6SUHWUi/JuazlqwwQd2OaexPvsoEP61tVyD+I0mHVwAA
AAAAAA==

--------------ms070507000502000404020305--
