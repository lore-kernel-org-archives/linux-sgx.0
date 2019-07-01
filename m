Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D02C06510
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 23:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6FA21721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 23:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="DpnaKM3/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGAXLz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 19:11:55 -0400
Received: from sonic308-14.consmr.mail.gq1.yahoo.com ([98.137.68.38]:46578
        "EHLO sonic308-14.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbfGAXLy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Jul 2019 19:11:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562022712; bh=lY9V4OGAsGHxsQ22U8YZoThrx0VRZhg7VWnTyLOZ2oQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=DpnaKM3/4g3yG+ABL5z5eXk0oQVWdncUby09llu7vAx4Q4wQ/a8bHEyBE3iX9KIXpIGk0u/FRkK2FevAmNctjSXZtwguji6BRJZhpddgBBoseOXxGTvclBCJlWuQdXFikUeVCy4fweZpPbFYw+RfyNgCqPmMfQrxU7ZhZkT10Nl8DsNmkH1ruNGJ5LCsnQeoMsvfGmnsLAN+/pnYxcv1i0bMPdgZ3zGEWOKa6F42yXAwssyDHS8svF5mvTh6ofAiLOl1XwXGpriFaI2CwKdGMH0Mmsq4HSZBLf9QlGyYz29W03WM0kLI2GMMLkB/6RF2brQTQuKdhTWcd7yXniaY5w==
X-YMail-OSG: QQ1tSLwVM1lzzQl4RFcKCPzHiAyBZ9HFDSrSQXiOe1XQXkYJdbe7PESCKNkLcoI
 nTwe0uejHF6BheFGEQEtUzh3_c.47PDlwHWpas4VapdpqVo1yBXcH4T6UjlKo0gKV4NQvpT5aaSa
 P4LHYisysev8RkurYP7.5iTDdiNd6GikxBwCEHRf.QYoC9cz8ufnCtLmJ_hpfbUrkidK9Fh3AxsP
 upsLgDbLY_Cs5Hs5AnZchQU3YrRqlpysaHImg6MdV_BT2Hlcn7rr0A4_b5VrTrgUbKzxgOCvV.1p
 DB2Qf.u.Lryp7m1Us.gKNRNzAyd1.t3yrODCo9zCHd79Dpwg3B3nYXcFkPGRVklelOCEUwb39YR3
 e2SgDu8p06nqNeoJJpyVf5Z7R9Y2sSUIyv.Z7BkxWv0uGm4ClYL.t82lrgD6EF01_EtGTDHS3zfJ
 2..lzL0euN4nriS43V3PF2vvIhXfkImGxi9vidjHWOcBrTKLzN4s5I2RaF3KGW6FnUcYqMB6g.e8
 XaYeVHWYtD5jyOM37FjhakFS_w5qq8.OaBq24Ka9oiP7Q2B5JrMnmHYakSjjwtWjpLwsl6lUomp9
 9l7fxVMWza17XEKS2hVnDJn_Lhm3uGWGMEveI5glUPE0IBCvIj4jV6c.3fbsNHSNl6SnwEfxKnx0
 0KxQ7Uqffc3mx9nMamXgNvI.k0tVvSH0.HtMKU0LXvzE3.b7ORivLoLyzmu42xvpHZx0QfNtNM97
 hBCplbbgxf_ys5ZXfSTfNPamBfUGqTVszuVrwDK4ffa5UX0jQhLQs6vsnHRxvSgZUiudMv43Dbb6
 3X2YcfIIjZspBrL4VJItaH0Z0SDPbZGQJg_wvvXtIbhMCPH0ecTlELmkiY6hCRSFpst83AiGP4ur
 Bynf9K8bVP45OG53rWy_X8xLjvfXKB1anLkzgOWjk4wM4bZAWqk.VJNW5K1tsD38fcLvw.1Gs7nd
 SrwNffKrxsTlOpTB.uLJkYLdXCCKYtGJKda97Tw2.BAALu9raevELCfmDRyVLLNt4eFtvCDUoYLR
 HVyQ6prarBrboalYAh31wYIlBF2f4fLf2flGQaKQXVYxvwO._vcVrKzSyhD54x4qiudu81mkiLvN
 GG09K8uc56AI8aAbQiL.JhXhwIflIm8giNlb9xdQqqbVEzJzND_E3AxhfvBJbTQXRLj86MEap6gS
 2ounnjtgRBM7IbgMtH0Q2wxKYhCxFvyU_gzpe60.D7pRcBUoJbhLK4dNBQALb31JrLqhvdzucCBq
 ykA5Lt_D4peF3f8z8oXDko9OX5Nf4f8T6LUjy4KlBGoU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Mon, 1 Jul 2019 23:11:51 +0000
Received: by smtp426.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 2d072199722424ec91806e2bdf1a9405;
          Mon, 01 Jul 2019 23:11:51 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        casey@schaufler-ca.com
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
 <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
 <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
 <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
 <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com>
Date:   Mon, 1 Jul 2019 16:11:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/1/2019 2:45 PM, Xing, Cedric wrote:
>> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
>> owner@vger.kernel.org] On Behalf Of Casey Schaufler
>> Sent: Monday, July 01, 2019 12:54 PM
>>> If you understand the purpose,
>> The purpose is to support the SGX hardware, is it not?
>> If you don't have SGX hardware (e.g. MIPS, ARM, s390) you don't need
>> this code.
> No, it is NOT to support SGX

Then what *is* it for?

>  - i.e. SGX doesn't require this piece of code to work.
>
> And as Dr. Greg pointed out, it can be used for other TEEs than SGX.

That sure makes it sound like it's for SGX to me.

>  It doesn't contain SGX h/w specifics.

I never said it did. But no one ever suggested doing anything
here before SGX, and your subject line:

	"x86/sgx: Add SGX specific LSM hooks"

says it does.

> It is compiled out because there's no module calling it on other archit=
ectures today. But it doesn't conflict with any h/w and may be useful (fo=
r other TEEs) on other architectures in future.
>
>>> then why are you objecting the lsm_ prefix as they are APIs to be use=
d
>> by all LSM modules?
>>
>> We name interfaces based on what they provide, not who consumes them.
>> As your code provides enclave services, that is how they should be nam=
ed.
>>
>>>  Or what should be the prefix in your mind?
>> I'm pretty sure that I've consistently suggested "enclave".
>>
>>> Or what kind of APIs do you think can qualify the lsm_ prefix?
>> Code that implements the LSM infrastructure. There is one LSM blob
>> allocation interface, lsm_inode_alloc(), that is used in early set-up
>> that is exported. As I've mentioned more than once, enclave/page
>> management is not an LSM infrastructure function, it's a memory
>> management function.
> It doesn't manage anything.

Sorry, "memory management" as in all that stuff around pages and
TLBs and who gets what pages, as opposed to keeping track of anything
on its own.

> The reason it appears in the infrastructure is because the decision of =
inserting an EMA depends on the decisions from *all* active LSMs.

You have not been listening. Most LSMs use VFS. We haven't rolled VFS
functions into the LSM infrastructure.

> That is NOT new either, as you can see it in security_file_permission()=
 and security_vm_enough_memory_mm(), both do something after all LSM modu=
les make their decisions.

Did you look to see what it is they're doing? If you had,
you would see that is nothing like what you're proposing.


> Would you please explain why you don't see those as problems but callin=
g EMA functions in security_enclave_load() is a problem?

The enclave code should be calling security_enclave_load(),
not the other way around. That assumes you're using the naming
convention correctly.

security_vm_enough_memory_mm() was discussed at length and there
wasn't a clean way to get the logic right without putting the code
here. security_file_permission() has the fs_notify_perm call for
similar reasons. Neither is anything like what you're suggesting.


>>> And I'd like to clarify that it doesn't break anything, but is just a=

>> bit different, in that security_enclave_load() and security_file_free(=
)
>> call into those APIs.
>>
>> There should be nothing in security_enclave_load() except calls to the=

>> enclave_load() hooks (e.g. selinux_enclave_load()). There should be
>> nothing in security_file_free() except file blob management calls to t=
he
>> file_free() hooks (e.g. apparmor_file_free()).
> As above, there are examples in security/security.c where the hook does=
 more than just calling registered hooks from LSMs.

And as I've said, that doesn't matter. You're still going about
using the LSM infrastructure backwards.

>>> But there's a need for them because otherwise code/data would have to=

>>> be duplicated among LSMs
>> There's plenty of code duplication among the LSMs, because a lot of wh=
at
>> they do is the same thing. Someday there may be an effort to address
>> some of that, but I don't think it's on anybody's radar.
>> As for data duplication, there's a reason we use lots of pointers.
> As stated above, security_enclave_load() needs to do something extra af=
ter all LSMs make their decisions. How can pointers help here?

I can explain it, but you clearly have no interest in doing
anything to make your code fit into the system. I have a lot
of other things to be doing.

>>> and the logic would be harder to comprehend.
>> Keeping the layering clean is critical to comprehension.
>> There's a lot of VFS code that could have been implemented within the
>> LSM infrastructure, but I don't think that anyone would argue that it
>> should have been.
>>
>>> So that's a trade-off.
>> I remain completely unconvinced that your proposal represents a good w=
ay
>> to implement you scheme.
>>
>>> Then what's the practical drawback of doing that?
>> Name space pollution.
> Alright, I can fix the names.

Good!


>> Layering violation.
> Not sure what you are referring to.

The only places where the blob freed by security_file_free()
may be allocated is security_file_alloc(). The security modules
are welcome to do anything they like in addition, provided
they clean up after themselves in their file_free() hooks.

If SELinux wants to support controls on enclave information,
and that requires additional data, SELinux should include
space in its file blob for that information, or a pointer to
the place where the enclave code is maintaining it.

That's the way audit works.

> If you are referring to buffers allocated in one layer and freed in els=
ewhere, you have got the code wrong. Buffers allocated in security_enclav=
e_load() is freed in security_file_free().

It's up to the security module's file_free() to clean up anything that
wasn't allocated in security_file_free(). Interested security modules
should call enclave_load(), and put the information into their portion
of the security blob. The module specific code can call enclave_file_free=
(),
or whatever interface you want to provide, to clean up. That might take
place in file_free(), but it also might be elsewhere.


> Whatever else allocated in LSMs are not seen or taken care of by the in=
frastructure. The purpose of allocating EMAs in enclave_load() is trying =
to minimize overhead for non-enclave files, otherwise it could be done in=
 file_alloc() to be more "paired" with file_free(). But I don't see it ne=
cessary.

Try looking at maintaining what you've put into the LSM code as
a separate entity. It makes it simpler. Really.

>> Architecture specific implementation detail in a general infrastructur=
e.
> Stated earlier, it doesn't contain any h/w specifics but just a TEE abs=
traction.

Then put it in the TEE system.

> It could be left on all the time or controlled by a different config ma=
cro.

True in any case.

> It is contingent to CONFIG_INTEL_SGX just for convenience, as SGX is th=
e first (and only so far) TEE that needs attention from LSM, but there co=
uld be more in future.

All the more reason to keep it separate. These things never get simpler
when they get more generalized.

>>> If no, why would we want to pay for the cost for not doing that?
>> Modularity and maintainability come directly to mind.
> Putting it elsewhere will incur more maintenance cost.

I don't believe that for a second. 40 years of C programming
have taught me that trying to do multiple things in one place
is always a bad idea.


>>>> ... and the notion that you allocate data for one blob that gets
>>>> freed relative to another breaks the data management model.
>>> What do you mean here?
>> You're freeing the EMA data from security_file_free().
>> If selinux wants to free EMA data it has allocated in
>> selinux_enclave_load() in selinux_file_free() that's fine, but the LSM=

>> infrastructure has no need to know about it.
>> EMA needs to manage its own data, just like VFS does.
>> The LSM infrastructure provides blob management so that the security
>> modules can extend data if they want to.
> You've got the code wrong. selinux_enclave_load() doesn't allocate any =
memory.  selinux_file_mprotect() may, due to EMA split. But that's transp=
arent to all LSMs.

=2E.. and the LSM infrastructure doesn't care and
must not be made to care. It's all up to SELinux.

> The LSM infrastructure doesn't know anything about what LSM modules do,=
 nor does it manage any buffers allocated by any LSM modules.

Right, which is why putting your lsm_ema_blob is wrong, and why
forcing into the file blob is wrong.

> EMA is currently managing its own data. What's needed is the trigger - =
to let EMA know when to update its states. The trigger could be placed in=
 LSM infrastructure or inside individual LSMs.

Yes. The latter.

> The reason to put it in the infrastructure, is that it depends on the d=
ecision of *all* LSMs whether to insert a new EMA.

That's basic stacking behavior. "Bail on fail", which says that once
denial is detected, you're done.

> That's similar to vm_enough_memory() where the final __vm_enough_memory=
() call is made by the infrastructure but not individual LSMs.

Do you really understand the painful reasons that case is required?
And if so, why you aren't taking steps to avoid them?


>>> EMA blobs are allocated/freed *not* relative to any other blobs.
>> In the code you proposed they are freed in security_file_free().
>> That is for file blob management.
> Yes. EMA contributes to the file blob. But it only frees memory allocat=
ed by the infrastructure itself, not anything from any LSM modules.

That's not the way it's supposed to be done. The module tells
the infrastructure what it needs, which may include space for
EMA data. The module asks EMA for the data it needs and stuffs
it somewhere, and the file blob is a fine choice. The module
cleans up in file_free, or at any time before that. If no module
uses EMA, nothing goes in the blob. If two modules use EMA each
is responsible for the data it uses, which may be the same or
may be different.

I've looked at your code. Making it work the way it should would
not be difficult and would likely simplify a bunch of it.=20


