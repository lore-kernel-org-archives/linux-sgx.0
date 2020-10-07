Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C30DC41604
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 16:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC69A20789
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 16:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Ok5ZzRYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgJGQN7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 12:13:59 -0400
Received: from mail-dm6nam12on2109.outbound.protection.outlook.com ([40.107.243.109]:36448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbgJGQN7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 12:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK8KnI4utRKdKQDPxkJOvzSqrZ4UeISHMTeV2j45BbUjhExuTOUaiNQf9618U79U8kwE0LfIQRj6P4NMSPhIbh5itnwFEvyQIVKvww7OCl6ZW0ASgf0MNJIcgddzYGPK2s6WEZGEhjaZXlfsGMOUP+/F+mCeI7xmNNu9YWzFNAUABmYX51ZE/ZVxkWcSbek+eJ1quKdulZnR/FA9+vHt+56SIRNPQrv0RF3Jra/n3oDGcnoFG4fa6lN/OgUysbJbMAJ2obzoShIqfrOB0JkUg8PcjJqYEFk2jyHlg8oI4MDlLpsm+WYVtOatOry5XptVo0k1iMnqHvTDg4Dsqj7UuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kihemDNlYJVVxSt574tn9wnR6L4H1o41PwtygZBJrs=;
 b=hsy9F+bOAIQ24QHtpXsqveBAYropwppiawYAQp6Ek5wEm3y+g/lMg5S6cVLApljJ7maOLPKMKtua+rSBRnTVZCkFxait/UJEVlvqxOJQqTQZ6998l6AjElrICzOCWgOEzMHJywPmsEeaBG+LNveslK8y/4k/Zpff4ZaNurfCSULY8z6+qzRH7hCJcOITtzZJRBz7UII9wzFv7LO0O32SXzhDORvzgSMncz/jPz/NuEombFjZnwrckQjXJqRbNPUWCx9OC1IO7/RgFIHOTj+dRkBJxvtVZ0OzkQokDRJovMoDJ6HXGe8+UBJKDqW5m1w+AOfmqpIHxRTIzq+3MzI/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kihemDNlYJVVxSt574tn9wnR6L4H1o41PwtygZBJrs=;
 b=Ok5ZzRYNZFr1ErCFjoIQW+RXwCn6uHoOzhcu/nXvAjC5+0ARuBWpROPHyoTk7CdsG+2pL90SNNj9CO5Yewlfw0nTwC3uwuysQYdaexCNUvDn97FE7E8Fc4h4eXuLnwMsVGY9YhlHgtHoYVwdicac+7AVue6r5O/ax3HvkGQxVtU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB4845.namprd11.prod.outlook.com (2603:10b6:a03:2d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Wed, 7 Oct
 2020 16:13:54 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3455.023; Wed, 7 Oct 2020
 16:13:54 +0000
Subject: Re: Unable to load large enclave
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
 <20201005225652.GD15803@linux.intel.com>
 <20201006151328.GA109815@linux.intel.com>
 <20201007154938.GA19072@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <f362318e-2d14-c82d-82a8-35c35842f84c@fortanix.com>
Date:   Wed, 7 Oct 2020 18:13:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201007154938.GA19072@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070005060202070904010108"
X-Originating-IP: [213.127.14.5]
X-ClientProxiedBy: AM3PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:207:1::19) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.14.5) by AM3PR05CA0093.eurprd05.prod.outlook.com (2603:10a6:207:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39 via Frontend Transport; Wed, 7 Oct 2020 16:13:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fefe459-b00f-4f80-4c88-08d86adbfc93
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4845:
X-Microsoft-Antispam-PRVS: <SJ0PR11MB484564203730402829719E8FAA0A0@SJ0PR11MB4845.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJiACaCXT7C/K87ziQPYyAeN6dTXhPVYDjihMwAd7/lzV7brohqMRTjV9OZXsRz61Aur+AxCPy3JxE5E+2wA1AsPrkilM6VZiHpefk+hOh09QDJL4w6izrkNVbvZ2dOBmzI+7Pcy6/mP7pRxSdVoKqcOS8Hiu9AmZux/7A101P4THFrE98/pAZh3LbqRKr/LlZbEKn5aSOgMtMtLIYa8pMyTMT6Eu5+aT/bXRi5jc9oB5rjTcD1GvbOiFEgdlT0fSQh4d9DTH6+Pru8SE0U5KKqj0PzLnowyw/AJTuaGGpmFsTdaxBk4eosL5AovegcKn62xESlTEqbUuC9jNMM5+H6i9ZrIjl3l2XVsxHbq2hS05vAss3fJCHLtZu6pXxaCEv+imXzBdagy7sdJoYoD2IPUpa+ThTNG5Xypt5cnDKRabpt5RKrTth2PPE5mEwM4UPeXfuFZI0YkBob0mIUruw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(396003)(376002)(136003)(346002)(53546011)(83380400001)(6666004)(36756003)(86362001)(956004)(2616005)(16576012)(316002)(16526019)(52116002)(31696002)(186003)(110136005)(26005)(33964004)(966005)(66476007)(66556008)(6486002)(83080400001)(4326008)(66946007)(8676002)(5660300002)(478600001)(8936002)(31686004)(2906002)(235185007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nLSS7iKf+GhJp/FxShXYCkLQf2mhzrSu47CYXrIL9SEdYzZCVbhs3qu7Ro9OMfIRHt1oG6+gHr/NZ8TUvTEYmqD9MVftt1qSYcpqXtesJPNwMxXlY6Ns6Xd70HhW/VtalP6aASnugdJ8w30wHFOxmc3ZO1M/NcmwC7AKVHLga/PVweAy2+03Wq4O6TyUaY+brcDV/p6CPGkk7nTB++YaEpqClk0LjlXvVAP1S8M1x78a9aZ0jd5fLEHkrdtI08K3l12vp5D+p9IjfOcCxZlAe3fMHh6q0WQ383mi1jJ4FFc36tCTHoSXgojoxpUfGQtdAiPfNKZjY/hS9Py0qT6IYch9ZNzPnoLVpjlch+0Suf5t7tK7I/wBBA4N8OUt/Jrh4/SYizQfslXnv0HHQl+3wq1RiMXp5cIMd3fm+kGltXw9WSOBldaxDYv0qZ8LJDoAPOBw+kWIONZCAY6yst8vxEsfBF2mMWjaROM+UyhBDI+P5tmxIosu7n8+nQGqAmjQhw04ysulQhc11pkaZ49pB63E+/9IlebeRuwXQAcCihTjPt8EtbBpI8QD+3eLNXqsyh1/o78yGQ0pmclkpG1giBsh+0nWWtZW1vtW7MHZt18GDEr8x//qLWJ2OQPARR2udOBvG1d9UfA6St/UD3U9PQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fefe459-b00f-4f80-4c88-08d86adbfc93
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 16:13:54.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmDPhqKdi3r5SUXczvwqFjilJNlBH8h2IKmk51/NRYrBz98eZs0zLBZGAtw3r3+/Qo1ApHGwQ0MgTmdtPFYiDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4845
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070005060202070904010108
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-10-07 17:49, Jarkko Sakkinen wrote:
> On Tue, Oct 06, 2020 at 06:13:28PM +0300, Jarkko Sakkinen wrote:
>> On Mon, Oct 05, 2020 at 03:56:52PM -0700, Sean Christopherson wrote:
>>> On Wed, Sep 30, 2020 at 02:45:54PM +0300, Jarkko Sakkinen wrote:
>>>> On Wed, Sep 30, 2020 at 09:12:06AM +0200, Jethro Beekman wrote:
>>>>> On 2020-09-30 03:16, Jarkko Sakkinen wrote:
>>>>>> On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
>>>>>>> Since the latest API changes, I'm unable to load a large enclave.=
 The
>>>>>>> test program at
>>>>>>> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclave-=
test/src/main.rs
>>>>>>> always fails with ENOMEM after loading 0xffd6 pages.
>>>>>>>
>>>>>>> I've tested this with v36, if there's reason to believe it has be=
en
>>>>>>> fixed I'd be happy to try it out on a newer patch set.
>>>>>>
>>>>>> I recommend using v39-rc1 tag that I created for testing because A=
PI is
>>>>>> reverted back to be compatible with v36.
>>>>>
>>>>> Not sure what you're saying. I tested with v36. You're saying v39-r=
c1
>>>>> will be the same? Or did you fix the issue since v36?
>>>>
>>>> v37 and v38 has an API change that is reverted in v39:
>>>>
>>>> https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.intel=
=2Ecom/
>>>>
>>>> I'm not sure of the root cause yet but you asked to try to out a new=
er
>>>> patch set and v39-rc1 is the best option.
>>>>
>>>> There was off-by-one error in enclave maximum size calculation fixed=
 in
>>>> v37 (it was actually a bug in SDM inherited to the code) but that sh=
ould
>>>> not result the situation you just described.
>>>
>>> My money is on the XArray changes, that's the most notable change in =
v36 and
>>> IIRC the only thing that touched EPC/memory management.
>>
>> Yeah, that's what we've been speculating for some days now. That's
>> somewhat deprecated email. It all started to enroll when I asked
>> Haitao to turn CONFIG_PROVE_LOCKING on, and we got the information
>> required to root cause the bug.
>=20
> I run the failing test and filtered SGX mmap's and ioctl's with this
> eBPF script:
>=20
> kretprobe:sgx_ioctl /retval !=3D 0/
> {
>         printf("sgx_ioctl: %d\n", retval)
> }
>=20
> kretprobe:sgx_mmap /retval !=3D 0/
> {
>         printf("sgx_mmap: %d\n", retval)
> }
>=20
> This results zero positives, i.e. empty output, when run with bpftrace.=

>=20
> I'd go instead after RLIMIT_AS [*].
>=20
> With these conclusions, I'm done with this bug.
>=20

How can it be RLIMIT_AS? With the current flow, you mmap the whole range =
before mmaping the individual pages over it?

Also, I can easily load a 1GB enclave with the old driver.

Also:

$ ulimit -v
unlimited


--
Jethro Beekman | Fortanix


--------------ms070005060202070904010108
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMDcxNjEzNDlaMC8GCSqGSIb3DQEJBDEiBCB8
QSwFG8sihglxaXTvVIPF/0oqwAqU2dNuIQ/ELaZFyjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAFKSwk3VIB4seXLnjPm9p100tGKdgFwd/Htk3ccqHBNX3s6GHpcy
jR7dO7n+hnMTeLr71UwTV+vdoOp5l/a7prEPfo5PW9u3GuWjeoXm3xjl1B/hjOC70Tndeqhh
2FQksiUi6wA4TmwKX5rZYw/ejdFlUWoBHlbiQQWnbOIKzGbME0f/gxFNdsbIGMvyJnFlyDaB
5UpF9Y2rIQK/FA/uG7eVGN37UbCBvagIWrZqLNRJbhIjsD93LBPy8hknZA05LVNn4MDkTwyG
9njkVanr+SdF8R9a3cKqKmtGYQZdbW0pNQLR4ZCMwpjgzUq/kJ3C/NL0PNxQ4ajfC9I0ogKj
4ToAAAAAAAA=

--------------ms070005060202070904010108--
