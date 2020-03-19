Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3E4C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 11:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01CC120740
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 11:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="mwajUyYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCSLuP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 07:50:15 -0400
Received: from mail-dm6nam12on2125.outbound.protection.outlook.com ([40.107.243.125]:7768
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726188AbgCSLuP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 07:50:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDXzA9L1qhmM+ZnCsj4T0LC17sAfWmP+m//XrX9cXRJINzFerWhiqfkRgL6mz2ZH6aX8YnU2cgARJZNPcrAfD3dsS1RwyQbowF5/srpWuiKgjkstdzMKseckE9m8pJ4d0njBS8IRdB1KNl7mSF4yqF+fbzbmjFqyBp0I0OV5v7bquH88IDOpExsXqxD3iDMrW60WQjS2kPZQk6j4yq4h0EH6rAhnWdPU7DJ/JCc+8wN2bjRMp1jogokKqRnYQpR6uqo2UK0Yd7kaeGzCb86E/m6I6nK2HJ3R6RHCmmQWJ40GoNf5+x04nnCNYdaT9SvymgEqKg4gx5tX/SzJIaPPrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vje/mJKZ3V+YxqpwjDUMmYdQd3oIMFlf6GcYYTkNypg=;
 b=OvajIsIFtekZ2zTVU1X0MB2Kv7SRnCdlHBsNk/PGxfA3Cvn4BAP+YelQ9/EnY7lMoOIledawDmxp6M52ur0YOTEHDTVP8gijEpVvKZ80KvIhUiITYrQEJg6rJejXH9pBkgV1ashHP70rgvQK0fgz8IehHWYxkElP83SwztV6evVbEk1zVvbsq9lHpWQEqXAu8UpAj9GTjG79FSnzVdz40zsNXdlQuJ7eb86+8BJb8evK/sa5P9icDziQy1MYvDnQwyDZRF6HupALullubWPgMqmEhc5igSGrEifX3joGqx7YLe+L7Y2Mx8Ijti0qgIoZOveCmgLfVbgL2tYy+7t8YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vje/mJKZ3V+YxqpwjDUMmYdQd3oIMFlf6GcYYTkNypg=;
 b=mwajUyYqPuPchgbe6bYN+9HKrXiiM1nJ6yvZT0UiEOWExjD6iH0xPXqaJOzn2IjK+kurOn9S5h3C1ZL1LGFy/q3WH71X4fgnwbWt7cxhUldDUJlayJgE4DRBwyfmo/sowKCawWmCg8na69bgPZT9QIdDe/W5fdrGxJtNhfqIrrU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4305.namprd11.prod.outlook.com (2603:10b6:a03:1bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Thu, 19 Mar
 2020 11:50:11 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a%6]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 11:50:11 +0000
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     assaf@enigma.co
From:   Jethro Beekman <jethro@fortanix.com>
Subject: SGX device & noexec /dev
Message-ID: <4db41057-910c-b686-0428-474debe382c1@fortanix.com>
Date:   Thu, 19 Mar 2020 12:50:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010804050601040203020206"
X-ClientProxiedBy: AM3PR03CA0063.eurprd03.prod.outlook.com
 (2603:10a6:207:5::21) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:da8f:6fb9:9677:3d38] (2a02:a210:a441:3083:da8f:6fb9:9677:3d38) by AM3PR03CA0063.eurprd03.prod.outlook.com (2603:10a6:207:5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Thu, 19 Mar 2020 11:50:09 +0000
X-Originating-IP: [2a02:a210:a441:3083:da8f:6fb9:9677:3d38]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 212c16fb-4f18-42b5-5402-08d7cbfbada8
X-MS-TrafficTypeDiagnostic: BY5PR11MB4305:
X-Microsoft-Antispam-PRVS: <BY5PR11MB430599BA9084A44ECACE98DCAAF40@BY5PR11MB4305.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39830400003)(366004)(376002)(136003)(346002)(199004)(2616005)(2906002)(66946007)(6486002)(31696002)(508600001)(6666004)(86362001)(6916009)(81166006)(81156014)(8676002)(4326008)(8936002)(564344004)(316002)(31686004)(36756003)(33964004)(5660300002)(66556008)(186003)(66476007)(52116002)(235185007)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR11MB4305;H:BY5PR11MB4260.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NIEG3mx460j7QhLrUMtB1d3wlT1tRSqoa993ngY5hlVlo8DxNVCEOacxCVkrMV6eT0fMgssRaTEUhLRwKNeT95IYf7eXGoss6lVfUrnMqcO6iHYfUFAy9lflYyY60eHn4+gnMN45ialVzrm4YC0ZjwVtcXNFmUId4kKmPsMionUZW+oa7L7i8/P5aP2Y+jpXbFd/vNqkV0BuWWbzNAhOTzamfC3OdBe/O4ULE2GuACk9qLzJEMjr8z1G25QrZ/V9IJG7aVAjO4KGbY23936nmsb8YXGwhneZYScKfbbvgC2X2hEW4Gk8HeSwYTSyNvA0JrqLJJIcr+sal3wzMg7E333LN9T52DF3nMFVZwzxyKKj/BW+DfYXSnVdbJEofDysasokXdPn4v68DA9EBEGqVBndtTLQVs0LWA0iFC8wSTFE7kMcu+2OmBlZMBTE/Lqg
X-MS-Exchange-AntiSpam-MessageData: fvTSSBVPv5k/m2gMYEYrJdm5olq7Qc6mG3RiUEhKqqll3DI1/aXjTyz+xCE4yOUBalzgmJQKT+Xvi2QWt9s01AWyuerTT/DVcGTwSUa9eVC6xCUV/Gy0WSvHfIW5dx8HGgPfG00KHlzV2nOuO/g2ggCLweEr7k4ScIgmMiM6Uo9X4/D/p4+EynrQNcGmJ9ABeT5woFy6r2Yken4SFV0r2g==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212c16fb-4f18-42b5-5402-08d7cbfbada8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 11:50:11.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmjL2zLNR0JiNFjPOqhUVEuXXWcB0iOsj7NwIOvBO58N++n2UawHjV18IWzLXqSEf4Ed14Hl0ijSxBE9qt6zxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4305
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010804050601040203020206
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi all,

One of our users discovered that some distros (notably at least Ubuntu 20=
=2E04) mount /dev noexec. This prevents mmap(PROT_EXEC) on the SGX device=
=2E Do we have any recourse other than telling distros not to do this if =
they want to support SGX?

--=20
Jethro Beekman | Fortanix


--------------ms010804050601040203020206
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMTkxMTUwMDVaMC8GCSqGSIb3DQEJBDEiBCDxzfCu5hnQ
ChWd4jrjLQmsu/Xjxdp9Y3QW0E5OeCxMozBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAZ6//EgRoK8aSrxGOUVxv68JXCmRFeH4G2S09Bp747oJmGpHHc++mrguT
kp1sEGxOItYn1FX+AwC946Z0sWcww5j6h/yJbQlUkOGxbFODE3bSPWXTwaTJgUisVcMjmB3U
rWvqQ/WAVMJ9WdL9f3tZH+yR9iJaTfQct+40ffynPpE1+FbgdQED9JomJKC7FmFH3JpQDBnR
+4g17axIXkNm2WwHmC03zqbXqWSWdTv9fkObynHQ4+Ui3lnRsy4cVArJKeYty0wIfUfckAY0
gT6QElls/2R9qYVVSTcudOKqjHnw3KsYQY60Z6/FbBB3GLLC2Z1wnInvhIkZHF6yHjP6sgAA
AAAAAA==

--------------ms010804050601040203020206--
