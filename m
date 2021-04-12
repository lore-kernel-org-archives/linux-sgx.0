Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB04C433B4
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 15:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87C761246
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 15:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhDLP6k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:58:40 -0400
Received: from mail-co1nam11on2135.outbound.protection.outlook.com ([40.107.220.135]:38241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238498AbhDLP6i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 11:58:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjN+Jh7Git2NWn0lIfuymIPmq/5C3xY7EM1niUfRj17iIRO287J/WEBujQn3lzKU9Q2Due7MFKzFl152SHkyFAjgjJtZGuUeUDDQcCqh4aZP9QG6F7nCWgHOfsEyH2/8AmB31jZqP09IIHDLul0SuIxKGic2ciWJqTF98E+hEHOEZRlOEvwR8JC/vc3BBLvGGfj6kuoMyqwcZLIVCXhIyyrdtlQZOXa7znkyPQLaayfFjAawLp994FGxkURKNxZC9LLZit1srVFX2hiZtcaQKB1Q5lCzlkMBozfIqan9sHadV4mAOwJ1a9bls3xvDgACNG6fan2JgzCmNxcDAzwqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWgE5K4x28NiHv+i3oTwQCPMhxmTnQ/ziC6jYGoqHS8=;
 b=N+hlIlL8KNvyowo8dk9DBUk+pqoAB143nwcPOO2FKI+tgA1pmqJnVvxK5VuhVYNU3IS/8+8Q4AUgmpO5/WxlvqzO0VafV5HfwUWTUNc/d3i8qGsPj11KQWO2dOmnt5hflp/jhic4oMIFk3b9BtZ5GsE+gE4dHnYPHZ+q1c2mjxR2QX8/1Zdg7d/ZAdWA1w88Seo8YpuPqxJir398Wzh35jD1wA4aIw/yWGvxh2wSxNZdkQRdYj5h9XH2nN6SIg62bYbjAZppweaoNKjXu0ElKqYEdpDevpdSOqaDV9Mv3/ksMSNnfyNWFv2/FZkUZNFD9LHzC28aRt3/ETuBht0DhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWgE5K4x28NiHv+i3oTwQCPMhxmTnQ/ziC6jYGoqHS8=;
 b=nnhnS7cNpa9uGuTfG9/+O3TK0ySdFcQe5WSv6XtWwy9IKFrpAs3htJGM86DrNC4tkIS/huDLOw89v+wBMwenFBHhmNnoUHIq96KSrfKA1yTKC0NFmyN6FGnMDuZO3ZwqeXFvWcrdf3Z8n8M+f2dUM8mE4tjmw2K2Uqy0MOx07QM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4243.namprd11.prod.outlook.com (2603:10b6:a03:1c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 15:58:18 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 15:58:18 +0000
Subject: Re: [PATCH v2 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
 <a05d07dc-1623-012c-5120-e30f64decae7@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <f3366028-286a-8543-0604-3db6799364b5@fortanix.com>
Date:   Mon, 12 Apr 2021 17:58:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <a05d07dc-1623-012c-5120-e30f64decae7@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040806030309080502020708"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 15:58:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce98364e-34b3-4aa3-7c21-08d8fdcbc99c
X-MS-TrafficTypeDiagnostic: BY5PR11MB4243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB424309779A5AD3A416C2A305AA709@BY5PR11MB4243.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxRQApWmXBxo8nQDyAwWaSvhHkRJEb37sbtxmIyCdYhvFIa8yX7TUaHXaBmZFazp1/tRQPZo8lStNss/EiU/+hPZLh0zHILiJVvozn0HtDFuxtooko89C32HgjXx6OJUmZvkH1JIueNGpSM3oVaxaqsRmfJAuqdQO7R/YhLyEm9QUhIqce8QaTWCc97Yu5ZLI7CKKpfuTKgedNOYfd3MALgbKVGgukdsqEwmMRgwbTnQm/A3dLlIYruJ0vb0RmMq7v2g2NWgcowWVb5c9+DsDYCfVbnlNtJK4vm4hXEAEoLgeFrCUlwD5IHsZAk5zl0Nrg4rUhlA73ay/t4IlJXSJ7jQZvxANasTeMv03QXqWpOC6QFbNib8DXhKVsyDirKHCWItcx4Pm+XEh+/Bp2dCTAFymvR+FjLBJ6quCa3W/L6twC89NIWKPYLKhIxkPnfPFk7JUO6wFWZjskEgabCoG+wv2vSa+HarUMslyohoUF/1mgoISw4gYG+A+0ETLKvbNfJz6InBf8BbzHwnZ7OyYKz502g9LnPPbLYRNjD6wESTjpMUe3G5w2fGGBo0W6nwBgNDrs4tWWhctoF7w2ouhV0zaNJ70DJ7lrh5ySmn8P862oqIdyplaLUlKu0X5x1ZbaOENwV0ntoenXQzdjFgdCdMrMrqcE6QU6BJgLc+vnFvhdB0qgkNyaZ87SNdD18MWJIOay65aIpWDj5JNVEHh8+ZXpP8MHuPye6k1gCfXoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39840400004)(366004)(136003)(66946007)(2906002)(235185007)(110136005)(38100700002)(38350700002)(26005)(956004)(6486002)(316002)(31686004)(2616005)(53546011)(16576012)(6666004)(16526019)(186003)(478600001)(7416002)(66556008)(36756003)(86362001)(33964004)(5660300002)(52116002)(66476007)(8676002)(31696002)(8936002)(921005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dzJiWVQ1bGtRUnlBQm11aDF3ajdhQ3JRM2Y0L3pzVERVR21CSG1IVDQ4STJ3?=
 =?utf-8?B?UnVTbktWSXBzcEJxMVZ6dlFJS2hhSkdRbWw5SC9aUGg4MnpVeHphVHNiWkZT?=
 =?utf-8?B?NnRvREgwdGh0aHJvaXVHS0J3OHo5SFdSQ2xRNDRISndITUgyZ284QmsyVVFz?=
 =?utf-8?B?SzFTeS91dWExU0tuZ2lOVkxQcEIxTllkSEdSbmRPdWx3WFZEdE5HUmdRVnpk?=
 =?utf-8?B?WjR0bGpaNGhETUpILzNDSFN2R0llcUtCOXY4QVJPL0dHRWQxY0dTU1ZiQlNi?=
 =?utf-8?B?TFJUUy96ejVFdXE2cVJjckpreEFKQndlbEtCVWczU0cvcXdRRjQrdG9mbXNS?=
 =?utf-8?B?VmYwRXZYVVhWWk44aW1Sd1JtMEkrOTIxb3IvYk03aTcvVVlrWGNMTHpaMndh?=
 =?utf-8?B?clNFUHIwQzY3cDVWM3FVaFhjUmpFa1g4RndNTTVWUFVYbnZxUDhPQWx2ZFFZ?=
 =?utf-8?B?ejRsRW4zdTNyWGRTdGpBS09DMkxJRlRGTHFPL1FCMHdibG5SbHEzZXordjJR?=
 =?utf-8?B?Rmg5bTI5K09SZDJQYkV1MnpDSW54b28rMDFXUU5XbmRPUzlveEh3Q3RZaEMw?=
 =?utf-8?B?eTJuV3V5NkkzelhMcmY4V05DTXdtY2tJRm82aTU0cFd4ODNPVlJSZ1doY3ZD?=
 =?utf-8?B?ck15UURpcVlpcXI1M2xTRmJLVnhmcUJvcFBlbmV1MWdqNzBvMlRZL0tOdCts?=
 =?utf-8?B?ZTZQeUVGZkl4d2lIZlZydUlzRFJNbFF5QjF2Q3drRllxdkFaK3BJdWUzdDRT?=
 =?utf-8?B?SmRGRzcxSkVuanRNMnRIUU5sUXMzMGtub1J4LzUzbFJGemhOS3ZnZmJtKzZk?=
 =?utf-8?B?MWJxRGNXajNGaERFRmxQS0d5U3ZaT2NxdHRvVFlIT09yNys0VFQxdmRtcW4w?=
 =?utf-8?B?YnNGNStOSjVuem42K3VGWTJ0K0J5OHlsVTZIa2ZFaUVqUHN5QUc4dmxNOS9K?=
 =?utf-8?B?Y1lBM28zcE02U1Fkd1NEeGZVdVF6OVFQMDFOVGdpc1B1SWE0RE9nOEtXNU5q?=
 =?utf-8?B?eDVFU0NwQ2VRZTFKVXRpMTZhYU4wZDc4OFV4SG9wSEhaZDlCa2d4eE1PS3dt?=
 =?utf-8?B?RS9TUmhNd1ByNXRMU3pjTXBEVjVnYkFYU0hJYjlQUTVJTGNXWjdDL1V6Mkgv?=
 =?utf-8?B?Q1QzUm1qNjdzMkllU0l0dThkUUpJajdRMHQ3N3MvRUxKbXUxL3o4bm1mamZ1?=
 =?utf-8?B?SGtxMjBpUjBHVkpSNXNNNjZPYXlrd2d4a1ZldU9wRDZzdkFLNVJxa2xMaGpE?=
 =?utf-8?B?bFZraHJNT2N3SDZzemJwTi93RHNlMnBIdlVIbG5EeWQrYWZtekE1UTdpZVZI?=
 =?utf-8?B?SUgwSHlqTzhmb1RFWmxMVGR0MStTQldhdlg1TW1Hd1kzQkxvVGQxY1RjcytP?=
 =?utf-8?B?dzI4OHROb0J6azVtcFFOM05VOGpiZGg4bVpjMWcvNFlLcGFkSkxGZnVFVk9M?=
 =?utf-8?B?UElkSGdsajF6UGhJVVRBZjRra1hvVExqWXZxSGdvVHU0Y0Nkdm5JZVFFS0Nx?=
 =?utf-8?B?VDNMVGVzTXZYUkdGcjhEY0ZCKzA4YWRYZjRUTkZWTW5RenN5REdXamI4TVNQ?=
 =?utf-8?B?SjRsSlM1ZnMwS21DekJRNDUyZk15K1dKV0FTcTA1ZTdpQks2M0J5S1NWRG1o?=
 =?utf-8?B?akNscnlXR0dQVTh5ei9iS2FBeVhSNWJNbmlNTmVqNXgvbm5yYThyV29OekZx?=
 =?utf-8?B?b3hYTkhZNERYVVRnNEhmNi81NEJUL0daZ0hzVTc1MW5DVTRmOERScVk0VDFL?=
 =?utf-8?Q?FevHWvN5E4bO7Q2KNJJ5W47Ue05ij/U0t/nL2Jm?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce98364e-34b3-4aa3-7c21-08d8fdcbc99c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 15:58:18.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXoYApUWAfjcV95dkv1YhC8PgknXN9/hz8lh6GGNK3XNNeaIig8GejwMnjcXRXr9IgpbaqhEIHum0v3BTmBv5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4243
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms040806030309080502020708
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-12 17:36, Dave Hansen wrote:
> On 4/12/21 1:59 AM, Raoul Strackx wrote:
>> This patch set adds a new ioctl to enable userspace to execute EEXTEND=

>> leaf functions per 256 bytes of enclave memory. With this patch in pla=
ce,
>> Linux will be able to build all valid SGXv1 enclaves.
>=20
> This didn't cover why we need a *NEW* ABI for this instead of relaxing
> the page alignment rules in the existing one.
>=20

In executing the ECREATE, EADD, EEXTEND, EINIT sequence, you currently ha=
ve 2 options for EADD/EEXTEND using the SGX_IOC_ENCLAVE_ADD_PAGES ioctl:
- execute EADD on any address
- execute EADD on any address followed by 16=C3=97 EEXTEND for that addre=
ss span

Could you be more specific on how you're suggesting that the current ioct=
l is modified to in addition support the following?
- execute EEXTEND on any address

--
Jethro Beekman | Fortanix


--------------ms040806030309080502020708
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MTIxNTU4MDlaMC8GCSqGSIb3DQEJBDEiBCDM
HRiMmmk5y0taE+ykZGzeQjGG1zW8iNdxds6ggVJOozBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAKLkudQm37R2GvP/joP6szgj/BhHSQXVMxRziMdnolRzMuwbK00J
Clwm0tkVfpuLXsyCf/woA0OAg6uiS49vTpOEPmjQgEn0vVvA3KqcHesf4Sgrh8NEWWQVfPlq
xPBqB6o88qCND91fVXwmcbiX6sK3QtXK7MgSCNZJW0oqX+I99nthnw2kWT1euSF+ebRK2QYu
4A8PdwFlu15mdyJiaJDrViUmzvgrMFLUTq7G0ebTIhRg6uDoSyxNIBSZDvLEVFoPIgTG9ko8
ygjzKTZt2tBMMcracW4qsVp7dTIiSC9RcuYKVSkQIESSnrOb5vYakAgNOvrfRpiIjjHcEbaw
DxwAAAAAAAA=

--------------ms040806030309080502020708--
