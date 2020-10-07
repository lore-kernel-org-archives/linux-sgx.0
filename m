Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB4DC4363C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 18:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87F22168B
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 18:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="dxBNIgT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgJGSPQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 14:15:16 -0400
Received: from mail-mw2nam10on2106.outbound.protection.outlook.com ([40.107.94.106]:55041
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgJGSPI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 14:15:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYPACfOKTjWDwlhy8uob0XsWmKjEwxpiouHc6KnNlVzzGrnds7T8OOV+GSPKzG+sim9y7lrQrMMyAxfzhDcs1gSlwBjED/mwF4b5RZI8lMBJys+FyNUlF4PKK39Lzj6DW0nJZu3UQECRQx4nO2mrhET+d6oSspn1LnvXzUhvGYbZ62SnJ0cZDBv11pHAyJurxQZ6uv22tCQC8gs9R3JVrH+WsK7dgbmUU+/7VkfUX75Yw3xmm4F9jJTLdLfDQ1p9gd8ABFG2MyWeg8cKwIkF8Btct6TB6Bp+Dyg+AfpnP7VBGqdjLTcw1/sB2d9ucItF7GAnRauSfmBI4nrIs9G5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmDvBQUJYDuOyL0mLV1EvYGy4GY9oW9auqW5lwOgAKw=;
 b=BNlgSzatO8ZHKzhi6f4Y7kZMccuMgw6HOCiOzhaSsDjdVMLK9aJsgXI7624cEaOPskAvTbZFgSFuNIAGEb2raVyvcaQwzvTSKpsZTl0YUvNbYqSAtu9AojInGqdnI2pyO2+Y/airsBpPVA/8pdbXUxXd8ocb51lTsoaWKYkX4mTtwmHuGOYM5G0EYYkbrgOiuO7f5EtRi9eh6PB8t89wkfDq48n7hrmmUNLKUW1g2jOd1UnNtpEQxnEAJGrilgy97/Fn4lA2l5M2K5pY9JcLPf8p/aAn7+uTQkHXskm3eckTtUXsU56PjPy0mLHioR6y7z9aa06MpwnHBmynvD9AOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmDvBQUJYDuOyL0mLV1EvYGy4GY9oW9auqW5lwOgAKw=;
 b=dxBNIgT97YUjEs1pscTTBVZsa+qhyz2GECAI9YX8zfN5iNxWQkQOYwO52rfQPBgMQXSh/dJ6maw7Rl96A31DbIp00zvfajj9Hw4reiU17tz1Wt+4bXkpnMEcUeGILtySyNOujdCf1gKZDup1N3wR1nxo0nKwmcFwG/paJ0Y42PU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 18:15:04 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3455.023; Wed, 7 Oct 2020
 18:15:03 +0000
Subject: Re: Unable to load large enclave
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
 <20201005225652.GD15803@linux.intel.com>
 <20201006151328.GA109815@linux.intel.com>
 <20201007154938.GA19072@linux.intel.com>
 <f362318e-2d14-c82d-82a8-35c35842f84c@fortanix.com>
 <20201007172058.GD3885@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <f56d8b2c-36ce-0852-c1d4-5e1b41a491f7@fortanix.com>
Date:   Wed, 7 Oct 2020 20:14:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201007172058.GD3885@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070702020208030404090503"
X-Originating-IP: [213.127.14.5]
X-ClientProxiedBy: AM3PR05CA0110.eurprd05.prod.outlook.com
 (2603:10a6:207:2::12) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.14.5) by AM3PR05CA0110.eurprd05.prod.outlook.com (2603:10a6:207:2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 18:15:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ce28ffb-fd6a-438c-f973-08d86aece97b
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4814:
X-Microsoft-Antispam-PRVS: <SJ0PR11MB48141C09F609D9B4C0A515A9AA0A0@SJ0PR11MB4814.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQfk/zwFIcPRG60yx6P/7Zlmm+EWuuzkxMnYgaX6Ljd4rPsU37OodX83p/Hao2v/2EhIrw2EE+XtmiA/5euvPlDCBPNMpiZzsWMhH5Xv47NEtkxaeY0cXPUBkEVcVQdiJ+Y+tF9be+eSi9AVLDXnYKvtIaf2d/87VOb7VsdNxZc06lYSxDXTUb1tTqC57DD2WoNOtUuFulfqdDwZx0tlfLRIXog0GwyLJ0De4S4j3kc4mNAPEC8yfjWfSYVNqYdXzH8kQ2kn7OE0qiIjz2LaBVL9gtKiemilHJ/OsHrXxtvKcahRFe/D53NEwFUFAksOUDvmfTDzivHkTzhuQ1ObmrKDvKwJ68BQJmo2CadYhFp08A/nBS/M7FpTE3YOPhfUCcQFDt9l4hv8OYpOigWEkM3HH+7OA6xeaVcMHwCCLY+PzttD05rvyruOVhbe9uxwLTIWwoew6FjTEamcaioRXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39830400003)(31696002)(86362001)(83380400001)(8676002)(66556008)(83080400001)(36756003)(4326008)(6486002)(66476007)(2906002)(8936002)(6916009)(66946007)(478600001)(316002)(26005)(186003)(5660300002)(16576012)(235185007)(54906003)(52116002)(6666004)(16526019)(966005)(956004)(53546011)(33964004)(2616005)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2T1gqX0+KwhjABFaDgMm9FwjBZg29FAbyWn2eraBLKaeuv7fFKgouN9E/K221jErWG6BQ1CYvltx8JuAHU6F54DGVVVgX6QO18KciG4bQMmUL6slvQvT2cBDmmbY0ZV4S6rmW8Mmuitc7UHpDMvecHo5DXKf7NS0Bzahgjzh3Z+3z6Ox02/ICIxp2IIHWNDyJd6c1Hx7BrqYCwZIvW+a8tbdmgbjhrh+BboE8Av8RkqaqF1PtOLHN0woIkAh5/IJXjZMClzJrk4zYxDEV4U3eVEAV4Z1/owRNLJKY4opO4XNRgXVGyZA8tpJn5j9Z1dpSJgX8zrRHSmjkjzvd1FHQ1hjA32jMNDpe252F9y1WYMnd3Qw5hfx1cTHxBd7uXtnzj//dYr/IPbfM+ZS6DMBJfB/XRgYKNfFd2pkJwx5cCMOhK5ZPsoPEXIP0NcTVyK/9UUlIeAoKMyH+gI46051swoQSeTSb743moAEQa8dmQ7MLF7rRygdCr2C3odGW0/kR3Q7Kv3PhZz/CSm4qFTFrqRKdqjUN8cylNoMaJU4BHzQTsouKfKay9VUAd5SQz6fWiFRYaKyIFgBbXaRx4bvGYU9VA29JTy1HFr3+uDaB97PSzQffurQyEsroHkLrWWNVUelIDzgVoneXrf/rOlh0g==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce28ffb-fd6a-438c-f973-08d86aece97b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 18:15:03.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCnfJw1OB8e8u7tK1iclLeOlm+Uetesr1f29Jl75SGk2fBUlJAq5BqIyzmWYy8FuufRJFiHcs/90/sg1GBk4Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4814
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070702020208030404090503
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-10-07 19:20, Jarkko Sakkinen wrote:
> On Wed, Oct 07, 2020 at 06:13:49PM +0200, Jethro Beekman wrote:
>> On 2020-10-07 17:49, Jarkko Sakkinen wrote:
>>> On Tue, Oct 06, 2020 at 06:13:28PM +0300, Jarkko Sakkinen wrote:
>>>> On Mon, Oct 05, 2020 at 03:56:52PM -0700, Sean Christopherson wrote:=

>>>>> On Wed, Sep 30, 2020 at 02:45:54PM +0300, Jarkko Sakkinen wrote:
>>>>>> On Wed, Sep 30, 2020 at 09:12:06AM +0200, Jethro Beekman wrote:
>>>>>>> On 2020-09-30 03:16, Jarkko Sakkinen wrote:
>>>>>>>> On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
>>>>>>>>> Since the latest API changes, I'm unable to load a large enclav=
e. The
>>>>>>>>> test program at
>>>>>>>>> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclav=
e-test/src/main.rs
>>>>>>>>> always fails with ENOMEM after loading 0xffd6 pages.
>>>>>>>>>
>>>>>>>>> I've tested this with v36, if there's reason to believe it has =
been
>>>>>>>>> fixed I'd be happy to try it out on a newer patch set.
>>>>>>>>
>>>>>>>> I recommend using v39-rc1 tag that I created for testing because=
 API is
>>>>>>>> reverted back to be compatible with v36.
>>>>>>>
>>>>>>> Not sure what you're saying. I tested with v36. You're saying v39=
-rc1
>>>>>>> will be the same? Or did you fix the issue since v36?
>>>>>>
>>>>>> v37 and v38 has an API change that is reverted in v39:
>>>>>>
>>>>>> https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.int=
el.com/
>>>>>>
>>>>>> I'm not sure of the root cause yet but you asked to try to out a n=
ewer
>>>>>> patch set and v39-rc1 is the best option.
>>>>>>
>>>>>> There was off-by-one error in enclave maximum size calculation fix=
ed in
>>>>>> v37 (it was actually a bug in SDM inherited to the code) but that =
should
>>>>>> not result the situation you just described.
>>>>>
>>>>> My money is on the XArray changes, that's the most notable change i=
n v36 and
>>>>> IIRC the only thing that touched EPC/memory management.
>>>>
>>>> Yeah, that's what we've been speculating for some days now. That's
>>>> somewhat deprecated email. It all started to enroll when I asked
>>>> Haitao to turn CONFIG_PROVE_LOCKING on, and we got the information
>>>> required to root cause the bug.
>>>
>>> I run the failing test and filtered SGX mmap's and ioctl's with this
>>> eBPF script:
>>>
>>> kretprobe:sgx_ioctl /retval !=3D 0/
>>> {
>>>         printf("sgx_ioctl: %d\n", retval)
>>> }
>>>
>>> kretprobe:sgx_mmap /retval !=3D 0/
>>> {
>>>         printf("sgx_mmap: %d\n", retval)
>>> }
>>>
>>> This results zero positives, i.e. empty output, when run with bpftrac=
e.
>>>
>>> I'd go instead after RLIMIT_AS [*].
>>>
>>> With these conclusions, I'm done with this bug.
>>>
>>
>> How can it be RLIMIT_AS? With the current flow, you mmap the whole ran=
ge before mmaping the individual pages over it?
>>
>> Also, I can easily load a 1GB enclave with the old driver.
>>
>> Also:
>>
>> $ ulimit -v
>> unlimited
>=20
> =E2=9E=9C  ~ (master) =E2=9C=94 sudo bpftrace sgx_ret.bt
> Attaching 3 probes...
> ksys_mmap_pgoff: -12
> ^C
>=20
> ~ (master) =E2=9C=94 cat sgx_ret.bt
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
> kretprobe:ksys_mmap_pgoff /retval =3D=3D (uint64)-12/
> {
>         printf("ksys_mmap_pgoff: %d\n", retval)
> }
>=20
> This shows that it fails before reaching sgx_mmap().
>=20
> /Jarkko
>=20

It's this one in do_mmap():

	/* Too many mappings? */
	if (mm->map_count > sysctl_max_map_count)
		return -ENOMEM;

I've verified that I'm no longer getting the problem when increasing /pro=
c/sys/vm/max_map_count . Why do I need to change this from the default co=
mpared to before?

--
Jethro Beekman | Fortanix



--------------ms070702020208030404090503
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMDcxODE0NDhaMC8GCSqGSIb3DQEJBDEiBCA5
Ahjgy/2CWSXgEgKeNUnXJnYxaPrwYpBUkErRNGZejzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAMLaaN+G35rvea6e/BJqFDhhELQeLtNLjywP94OOLi8DpmV3f5yj
3if/B6s9fZJ6VaZ3YiDGurs1qKNhBDcPAsFrQX1C3hmSVEMBsykSIA1y99H5RxhJlt45Otpq
awLT6Ghemj1Tr0SsI406cvd0AC5iaUXhQQ9C88GAYBwvIONo5SOmkdrWHybHG3zvngVyQSjn
QGQ/BPT3UjkdPTB66ockxhCS2P+DqYebEKKBejBmdvDHUJtIYT0QqBdTt7NnxSW4Lqr5fHhm
bUF/+W4hx4C/ZLieJYi0T5zpuoMN8KDZms0sRnYz6d+0anEY6bYI/3ydzxuOGb/IoAe6jiJK
4CIAAAAAAAA=

--------------ms070702020208030404090503--
