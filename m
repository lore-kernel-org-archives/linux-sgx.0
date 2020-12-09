Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB88C4361B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 09:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE39C23AA8
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 09:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgLIJI1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 04:08:27 -0500
Received: from mail-bn7nam10on2099.outbound.protection.outlook.com ([40.107.92.99]:4064
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgLIJI1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Dec 2020 04:08:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gETO6AsOiZ/ZJpO9MApI8KUeQlMpn7N84dZnQRvB2vJtGsz0xTvLysWrBGCEAPQdC6IK+wZaWDtcr2UwtE1BHyn6VvghJJeD5249tK7uFFNUCLqzNIcCVsL5BI0uQ+t5eK2Au2R3StFpfZP3Bw2dPamX2FHxPUwcRBJMRLfhWfKJlzBne0xuATDSWuoDGHaP4QaH515hIhVcmTt8WuNXiYgbjjqxymnaS0L9b8Eg/XaaqEeqtVhMSBaR3bnCakmrSwRkhfoIlF8rjAkQh4/hqKQJWKv51dyy+ANUuR27K+lJ4FTD3IDrQWjVIAYwMMD4LJwcUb3SJlM5UE+sGsOeaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BXK29whD8Sx6zZmMzG0W+XrTszkFUp/b5hFH67sqXU=;
 b=B3COE/1U2HgyZJh80hfhmgiWHbxr3jiZ5M+a5tCMgnKEt9eIfGs0LZAe4udA2WdRGY/wxthbEZ97wX9rrDK4lAGt9JhbAukqavjN7npR0GC4SCMjxFmgaO0s8nSCZ5oG9NTDdpt/1mN1MThu721ad3l4n1vKaR7RvvqcTNGoro9gCxS1TiA5y9OPHuy13u38IbHATqpkWZuaCNT0E1XwPIajZunj2Lpd3xp6g0dXwg9hH1PGjjJtjkAo7avF0BkuFXeqnA4oSbzzLMMb/iZKEZTrwqe0xaiTT4Q7Q46PnP0olPcJObQEuNLQbCA4O5/32MnQPftqLcu2oVG6EuzrXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BXK29whD8Sx6zZmMzG0W+XrTszkFUp/b5hFH67sqXU=;
 b=JznCJBkVkd45qrnRSt093T7An6u1msXEYkHUQcS8jcLz7d0+BAar9LqtiXYeUHLsFP8FJwAyzhN87rlHjzgc1Orm30ux+0Z36lnFSBWZHAY6eZXLcoOi63iGmtEP0sFfnhIntQvu8iI7v1ExKq9mwO8bC9tO4D27o1YpfJz35d4=
Authentication-Results: decadent.org.uk; dkim=none (message not signed)
 header.d=none;decadent.org.uk; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2630.namprd11.prod.outlook.com (2603:10b6:a02:c2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Wed, 9 Dec
 2020 09:07:30 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::84e0:4df6:7a70:eee5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::84e0:4df6:7a70:eee5%6]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 09:07:30 +0000
Subject: Re: Creating executable device nodes in /dev?
To:     Topi Miettinen <toiwoton@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        =?UTF-8?Q?Zbigniew_J=c4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org> <20201209004214.GA64820@kernel.org>
 <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <21496f3a-2acb-3ced-f08a-9916d991ee5e@fortanix.com>
Date:   Wed, 9 Dec 2020 10:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050707020903080501050109"
X-Originating-IP: [213.127.127.169]
X-ClientProxiedBy: AM4PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:200:42::27) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.127.169) by AM4PR0701CA0017.eurprd07.prod.outlook.com (2603:10a6:200:42::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Wed, 9 Dec 2020 09:07:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8082c9-a828-4a15-87cb-08d89c21db74
X-MS-TrafficTypeDiagnostic: BYAPR11MB2630:
X-Microsoft-Antispam-PRVS: <BYAPR11MB26300028C199F51385440A1DAACC0@BYAPR11MB2630.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KxncQVNXWNa8wB0qR3XqwhZLsAgNITX6Awlyo4B9TDtNARO8ufJm+oVE5ugKHZdpcJkC6CKx1K4wM8swydfXVnSTUatKXc3LbdU82wnm579MekGXgesjIg0w2eVHBWhCnWOU84vwlqnGEkhtVpNOvElwhJ3Mihh5UwzD1ub7+czR1rWqfPH8p2KcTRWBQ/GlE9wa8SaMO6wUMl8qvTwTv8sqJab1z2dHI5mWsmgFIECKP/ceqFt1cAeL2EdgSAQYzfG2ExLlvaXCNY0jKlL3y3kNd8/TX4bMVLvtxK18GcgodGIG1nl7H0IHrjcmLozh6J/qBAPws4ebPU5530zeXyT99GM/t42UhmUC7+7bGb72AQlXk2XDp3wiYFm4BxQZOUPq+7XFyIST0G8LFZ3CKeMcZzVcZs9e/3uLtGOr0M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39830400003)(376002)(366004)(136003)(66476007)(16576012)(66556008)(4326008)(478600001)(26005)(316002)(36756003)(16526019)(31686004)(110136005)(7416002)(54906003)(2906002)(6486002)(956004)(31696002)(5660300002)(235185007)(6666004)(8936002)(66946007)(86362001)(186003)(52116002)(66574015)(2616005)(83380400001)(33964004)(8676002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L0ovdVdoYnFjelJBNDBXZ2lFYzA3LzRZclFxWW5qUVJ2Rk0yWm9UcmZvQkgw?=
 =?utf-8?B?WVBhK1ViL1g1YmNlNmVSSSs1UDNCT0I1bXJtUWs0eklESkVsRENNSHdzWUZl?=
 =?utf-8?B?YStmR3JZN1hoN3hNb05uZ3FiMmdTMUozR3RPOFJpY0tUQ3ZHTUVRS2tYc0xu?=
 =?utf-8?B?UXJxRm9pK29vZVo4bWRrREVrTEdYNWZUbnlaV0ZWTFcycFBRYnBsUDMxbXdV?=
 =?utf-8?B?ZjJJUkg4bU5aMldaZzN3bHUwK2JhOC9CR1ZNSXFvTnM5Z2RqR0ROZnBCY1Qw?=
 =?utf-8?B?S1prNEFqRUlZRTg0R2pUaGd6RktNeCtCYnN6V0NuVnhwL3E2ZTNJbFgySWlV?=
 =?utf-8?B?WS9MbE1CanRhUkJtSDdvT3JRUi9JbVllWjl4VHhGYnhRYkN1SWl6UUpnQStY?=
 =?utf-8?B?TW1kVVlzV0xyelRJM3ZQY0ZRYVMxOE1IWjlsd1dwWHV4ajV1UW1oSW9xSm0r?=
 =?utf-8?B?Kythb1JZYkdJcHhPMmxMQUVFMHgvMjFwcUVFRXQxRXBhMDBvWFNESUlCeFZ0?=
 =?utf-8?B?R1MycFo4MHFxSHlHRmlPMmZnVDlOeC9qRk5uYklzVERlcTdKNUpSUHNsVGdQ?=
 =?utf-8?B?SVBiMGQ3bkJNNmhYSS9kZVU5alhZRE1RL2UvOGRHVE5JcXA0QXVnYkVuSWxD?=
 =?utf-8?B?aFlBQmdNWmd5eHZoS2NNYlNxRDZBT0lpZ29vQWpYS0NhN2dqQ1VnemhEdnQ4?=
 =?utf-8?B?L09Uc3pzamo3ZkZJSzJFODNHZW9wNXRkQW93MGhFZ3pGMXdUTWFDS1JoWi9y?=
 =?utf-8?B?cXdOSFZyUkVHNXBSOGxtZ3orYzYwWWk0VVZEV1B5eFBPTHMrT21BUkxPMVND?=
 =?utf-8?B?WmRCZkNBbCsxMjJHbUFad1JqMlBHQWp2bXlLc002WjFXd25iWU1wMUFLOTZa?=
 =?utf-8?B?NDFHamtqcW95ZXZSUjRWVTJpUXpJM0pjOUI0YVFSVmhHcTNBTTNhVVA1YW1H?=
 =?utf-8?B?b2NMVW9qbU5iczl0U1lranBiTmNDSGpxNXdueXNJTEpNNTBxK3UxQWNpbHhS?=
 =?utf-8?B?b2NxMDlYMnR6VXYzWDBqbmI4eUJBajM2bG11VXNlaTZ4bkFXTXFBS0k4V2t4?=
 =?utf-8?B?di9kb1FWL0FnVmFpTkFpbWk4eHB2RXU0MEtDdFRDS3FmQVZ6c3J2SFRuWkVC?=
 =?utf-8?B?Yy9wTWY1ZmdXbXpUVVVuZDBVeER6NWN6blhpaGVBcVpRZmUvc0lJaTNxY0pr?=
 =?utf-8?B?ZE1oWWF0U0RkekFZbmdDQXlzS3BmK2g1cUJORWhFaVdSbmVjNm9sMWxpbWJ1?=
 =?utf-8?B?ZjN5cG4weG1HQkJCSERNcWp2TEgxa2lnU3AyMUJ1VGo2Ni95SStvaURXNkl4?=
 =?utf-8?Q?qZMyOWZNja7QtdNLlH6KT/eV8shX8PNve2?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 09:07:30.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8082c9-a828-4a15-87cb-08d89c21db74
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RdR7bOFpVMGfqVRqM5RiOuD+nghpTxOJ2rD8k3NoGMS1CeRsuPcL3CW7hongA25oXmn3q5pk0NWZP5rt7t5Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2630
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050707020903080501050109
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-12-09 09:58, Topi Miettinen wrote:
> On 9.12.2020 2.42, Jarkko Sakkinen wrote:
>> On Wed, Dec 09, 2020 at 02:15:28AM +0200, Jarkko Sakkinen wrote:
>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>> As=C2=A0 a further argument, I just did this on a Fedora system:
>>>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>>>> No results.=C2=A0 So making /dev noexec doesn't seem to have any =
benefit.
>>>>>>
>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>> /dev is a writable directory (for UID=3D0 but no capabilities are
>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>> executables if it is also mounted exec (W^X).
>>>>>
>>>>> UID 0 can just change mount options, though, unless SELinux or simi=
lar is used. And SELinux can protect /dev just fine without noexec.
>>>>
>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also S=
ELinux
>>>> is not universal and the policies might not contain all users or ser=
vices.
>>>>
>>>> -Topi
>>>
>>> What's the data that supports having noexec /dev anyway? With root
>>> access I can then just use something else like /dev/shm mount.
>>>
>>> Has there been out in the wild real world cases that noexec mount
>>> of would have prevented?
>>
>> Typo: "of" =3D "of /dev"
>>
>>> For me this sounds a lot just something that "feels more secure"
>>> without any measurable benefit. Can you prove me wrong?
>>
>> The debate is circled around something not well defined. Of course you=

>> get theoretically more safe system when you decrease priviliges anywhe=
re
>> in the system. Like you could start do grazy things with stuff that
>> unprivilged user has access, in order to prevent malware to elevate to=

>> UID 0 in the first place.
>>
>> I think where this go intellectually wrong is that we are talking abou=
t
>> *default installation* of a distribution. That should have somewhat sa=
ne
>> common sense access control settings. For like a normal desktop user
>> noexec /dev will not do any possible favor.
>>
>> Then there is the case when you want to harden installation for an
>> application, let's' say some server. In that case you will anyway
>> fine-tune the security settings and go grazy enough with hardening.
>> When you tailor a server, it's a standard practice to enumerate and
>> adjust the mount points if needed.
>=20
> I think we agree that there's a need for either way to allow SGX (if de=
fault is hardened) or a hardening option (in the opposite case). For syst=
emd I see two approaches:
>=20
> 1. Default noexec /dev, override with something like
> - ExecPaths=3D/dev
> - MountOptions=3D/dev:rw,exec,dev,nosuid
> - or even MountOptions=3D/dev/sgx:rw,exec,dev,nosuid
> - ProtectDev=3Dno
> - AllowSGX=3Dyes
>=20
> 2. Default exec /dev, override with
> - NoExecPaths=3D/dev
> - MountOptions=3D/dev:rw,noexec,dev,nosuid
> - ProtectDev=3Dyes
> - DenySGX=3Dyes
>=20
> I'd prefer 1. but of course 2. would be reasonable.
>=20
>> To summarize, I neither understand the intended target audience.
>=20
> We have something in common: me neither. What's the target audience for=
 SGX? What's the use case? What are the users: browsers, system services?=
 How would applications use SGX? Should udev rules for /dev/sgx make it a=
vailable to any logged in users with uaccess tags?

Unless the system administrator/distribution has a specific reason to dis=
able SGX, /dev/sgx_enclave it should be generally available to any user p=
rocess (mode 0666). SGX just provides a different way for an application =
to execute code by using the ENCLU x86 instruction. Ultimately, any appli=
cation author could decide to use SGX in its design, including browsers, =
system services, network services, etc.

The device doesn't really provide any I/O or other hardware access. Even =
when the device is in use by a process, the OS has full control over sche=
duling and resource management. The only reason it's a device in /dev is =
to be able to provide an fd for use with mmap so that it can setup memory=
 ranges for use with the ENCLU instruction.

/dev/sgx_provision provides access to CPU hardware identifier and should =
be root/root 0600 to preserve privacy.

--
Jethro Beekman | Fortanix



--------------ms050707020903080501050109
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEyMDkwOTA3MjBaMC8GCSqGSIb3DQEJBDEiBCDA
HtVmnHyxwTr2QDVMg18wynjh2OIbpU28kyU9FI78rTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGzqhosEvxH945VlrAW3P9mkGPOIlg3G35atQzhAECyMEvor8QNk
ALMMeP0QgmwGkfj5XYDyPpMKyaSu6XdVV6C01qhPR/jlEUlcI9ZkYfze4MSHCItSOF67WP35
lnhq5rFaLHfkZT/YsJR1Dp07XB9qdvWlLvhkSIGijcb8zLpqI/LjfZcsOo+vLvAakCnbBOjS
nB9NI6+paIMquRy9CiqDNkOw2bUwyiOcQE6/q+dieAAfoqUWxk40sC5aqQZDuGNr2NqGZRMq
jKcSmqka12lg2b+baKL1T0mVSGSQ9hlTgv1W7wc8T9ub1kVLkTIhWC0OKCQ5HFYhhMdxlGtt
/foAAAAAAAA=

--------------ms050707020903080501050109--
