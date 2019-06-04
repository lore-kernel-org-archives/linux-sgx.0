Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA04C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 15:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 597272190D
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 15:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="VLcDLy1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfFDPeO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 11:34:14 -0400
Received: from ucol19pa09.eemsg.mail.mil ([214.24.24.82]:23493 "EHLO
        ucol19pa09.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfFDPeN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Jun 2019 11:34:13 -0400
X-EEMSG-check-017: 859882191|UCOL19PA09_EEMSG_MP7.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="859882191"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by ucol19pa09.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 04 Jun 2019 15:34:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559662446; x=1591198446;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=DB+T8oc0XZ5GNwDMLVp3GIc3krGlWESsDKst0JVbSxE=;
  b=VLcDLy1oAuYjq7gjDvoCZhJ2TNfL/A5YSBed9HqWO9QvOmtl8kbgL7RB
   cuzqmfBPVrgVLDt187lXEjszIizJq6sgd6MyPJ97BX733FqMKADqXaDFK
   yxi79EwrDhAMTuTMMnrifR3B4RVshOlBGRIC18xmzoSmAbFmlYKivtMks
   PWRhrWFeMZLDhhwLCAU2FBzSfi90ZUzioc6JPhr3TTBlTzfmzVf9Iy4j1
   9WBSCw/nEluhHXFxepitfZ/rNcDEtXOfojrldoqjpUB2edD1oSNslqtJS
   CMUPqcM4xEY/NnsjywFc0+w+DzfHhMRq4lu/LBd0Scqi3o486hVg8zm6G
   w==;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="28536247"
IronPort-PHdr: =?us-ascii?q?9a23=3ArZKpoRHf0Ga3Hqtb1ooxj51GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ75ocSzbnLW6fgltlLVR4KTs6sC17OP9fm7CCdQsN6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vMRm6txjdu8cSjIdtKas8zg?=
 =?us-ascii?q?bCr2dVdehR2W5mP0+YkQzm5se38p5j8iBQtOwk+sVdT6j0fLk2QKJBAjg+PG?=
 =?us-ascii?q?87+MPktR/YTQuS/XQcSXkZkgBJAwfe8h73WIr6vzbguep83CmaOtD2TawxVD?=
 =?us-ascii?q?+/4apnVAPkhSEaPDMi7mrZltJ/g75aoBK5phxw3YjUYJ2ONPFjeq/RZM4WSX?=
 =?us-ascii?q?ZdUspUUSFODJm8b48SBOQfO+hWoZT2q18XoRa+AQSgAeXiwSJKiHDrx603y/?=
 =?us-ascii?q?kvHx/I3AIgHNwAvnrbo9r3O6gOXu6417XIwDfZYv9KxTvw5orFfxY8qv+MR7?=
 =?us-ascii?q?Jwds/RxFEyGQPZkFqQsYzlMC2T1u8Qrmab6vBvVeari2E5qwB6vz+ixtwxhY?=
 =?us-ascii?q?nSnY8V1lDF+jl5wIYyP9G4TlV7bsS+HJtfsCGaKZJ7T8U/SG9roCY30qAKtJ?=
 =?us-ascii?q?G0cSQQyJkr2gTTZ+KIfoSW+B7vSeCcKipiin1/YrKwnROy/FClyu37S8a7zk?=
 =?us-ascii?q?5HrjFAktnQrnAN0AHT6tSfRvt94Eih3TGP2hjP6u5eO0A0lLfbK4U7zr4slp?=
 =?us-ascii?q?scrUTDHijslEXwkKCWbVkr9vKt6+TmZrXqvp6cN4lqhQHiKqkih8OyDOsiPg?=
 =?us-ascii?q?UOQmSX4/qw2bL98UHjXblGlvg2nbPYsJDeK8QbvKm5AwpN34Y49hm/FCyr0M?=
 =?us-ascii?q?gYnHYbLFJFfwiLj47yO17UOvz4AvC/g0q0nDdx2//GJqHhAonKLnXbjLjuY6?=
 =?us-ascii?q?ty61RdyAUv19xe6JNUCrcOIP/oW0/xssDYAQE9MwCu3+nnD9B93JsEWW2TGq?=
 =?us-ascii?q?+ZLL/SsViQ6+I0PeaDfokVtCz/K/Q/+/HujWU5mV4Gfam12psXcHC4Eep8I0?=
 =?us-ascii?q?WCZnrshMwMEWYMvgoiUuPqjEeOXiJUZ3a3R6g8/C00CJq6DYffQYCgmL6B0z?=
 =?us-ascii?q?2hHp1VZWBGDUqAEWzyeIWHWPcMaSSSLdFnkjEfUbihSokh1QyhtQPgyrpnKP?=
 =?us-ascii?q?bU9TMctZ75yNd14OjTnwko9TNoF8Sdz32NT2Zsk2MMWj82wKd/rFd+ylidy6?=
 =?us-ascii?q?h4heJXFdhJ6/NOSAc6OobWz/ZmBNDqRgLBYtCJRU6kQtWjBjExVMgxw94VY0?=
 =?us-ascii?q?tmHdWtlBXD0DSrA7MPkLyLHpM0+LrG33ftP8Z912rG1K45glk9XMRPL2Kmib?=
 =?us-ascii?q?Bk+gjTHYHJl0GZlqasdagGwCHN82KDx3KUvE5ESA5wTbnFXXcHa0vSrNT54F?=
 =?us-ascii?q?7CTrC3BbQ8LARO1dOCKrFLat31jVRKXfLjONPDbGKsn2e/Gw2Fxq2DbIX0YW?=
 =?us-ascii?q?URxibdB1YekwAV43mGMRIyBiC7o2LRFDZuD07gY1vw8elir3O2Vlc0wBuXb0?=
 =?us-ascii?q?1lzLe14gQaheGYS/8K27IEvyAhqy9qE1qnw93WDN+ArRJ7fKpAedM9/EtH1W?=
 =?us-ascii?q?XBugNjJpyvNbpihl8Fcwlsp0PhzQ93CoRbkcgyqHMl1hZ9JryC3FNGbTOY0o?=
 =?us-ascii?q?j6OqfLJWnq4BCvd6nW10nF0NmI/qcP6fI4q0jsvQyyCEoi/Gto08NP33uf+J?=
 =?us-ascii?q?rKFgwSXoz1Ukot8Bh6vb7aaDEn54zIzX1sLbW0sjja1tIrGuQl1hagf81YMK?=
 =?us-ascii?q?6fGg/yFNcaB9S0J+wsmlioYQgIM/xV9K4xJ8mmbeeJ2La3POZ8mzKrlXlI75?=
 =?us-ascii?q?pj0k2S7SZ8SvTH35Aew/6G2AuKTDb8jFG9ss/pnYBIfy0dHm26ySL8Ho5eer?=
 =?us-ascii?q?VyfZoXCWepO8C32tp+h5riWnND8F6jBlUG2NK1eRqIaFz92wxQ1EsNrXO6hy?=
 =?us-ascii?q?Sy1yZ0nC0xrqqDwCzOxPzvdAYAOm5RWmltl1PsLpWvj90BWEiobg4plAaq5E?=
 =?us-ascii?q?rjyahbo7l/L2/OTkhSYyj2LmZiUq2qurqFec5P54sisT9LX+SkfVCaVrn9rg?=
 =?us-ascii?q?Me0yPiGWte2T86eyipuprnhRx6jnySLHJooXrHdsF/2w3f6MbfRfFPxDoGQj?=
 =?us-ascii?q?d3iT3NCli7Jdmp8s2el43fveCmS2KhSppTfDHkzI6DtSa2/m5qDgOln/C1hN?=
 =?us-ascii?q?LnFRI20Sjh19llTS/ItgrzYpH316SmNuJqZk1oBF7668pnFYByi5AwhJ4f2H?=
 =?us-ascii?q?UBmJWV8mQIkX3pPdVYx63+dnwNSiAPw9LP5wjlwkJjJGqTx43lTnWd3tdhZ9?=
 =?us-ascii?q?6ib2wM2SI998VKBbyQ7LxFmyt1v1W5oRvfYfh6gzcdz+Yh52QGg+EIvwotyD?=
 =?us-ascii?q?+RArcIHUlXJSbsjQiH78iirKVLY2aiab6w1Ep5ndC7CbGNuAdcVW3jepg8AC?=
 =?us-ascii?q?Bw7t9wME7W3HLv7YHkfcHabcgPuR2MjxfAk+9VJYo3lvoSgCpoJX7ysmchy+?=
 =?us-ascii?q?4/kBxu2Iq3vJKZJGpw/KK2GAJYOifpaMMU/zHnlbxekdqO34CzApVhHS0GXI?=
 =?us-ascii?q?D2QvKyHzIdq+7rOByOET07t3ebH6HSHQ6Z6Ed6sX3PF4qnOG2QJHkc1d9iXg?=
 =?us-ascii?q?WSJFRDgAAIWzU3hoU5FgCwy83hakt55Soe5kL5qxdVy+NnLRz/UmbFpAqzaz?=
 =?us-ascii?q?c0ToSfIwRS7g1Y+0jVNsme5PppHy5E5p2hsBCNKmuDagRIF24JW1CECErkPr?=
 =?us-ascii?q?W05dnA7vKXBuyxL/bVYLWOr/BeWOmMxZ61zoRm+DOMPN2VPnZ+F/07xlZDXX?=
 =?us-ascii?q?dhFsvDnTUAVjYXlyPNbsKBvxe8+jN4rt6j//TrRg3v44iPC7xJPNVr+hC2h7?=
 =?us-ascii?q?qDNuGKiCZ4LzZYyo0DxXvSxLcD214SjjlkdyOxHrQYqS7NUKXQl7dUDxEBai?=
 =?us-ascii?q?N/LtBI77wm0QlNP87WkdL11rhkjvErD1dJT0DumsasZcYSOWGyKEvHBFqXNL?=
 =?us-ascii?q?SBPTDE2Nn3bLimRr1UjeVbqRuwtDWBH0D+IDuJjyPpWAy3MeFQkCGbOwRTuI?=
 =?us-ascii?q?O6chZ2CWjuV9DmahqgMN93kT0227w0hmvONWECLTh8b1lBrrqK7SNXmv9/AX?=
 =?us-ascii?q?BO7mJ5LemYnCaU9+rYJYwXsfdxAiR0ivhV4HI1y7ZO7SFEQuB1lzXWrtJ0v1?=
 =?us-ascii?q?6mleyPwCJ9UBVSsjZLmJ6LvUJ6NKXD95lPR3DE/A4P7WqOEBQHvNRlCtrou6?=
 =?us-ascii?q?BfztjAirj/JytF89LR5cEcHdTbKNqbMHo9NhrkADDVDAoBTT6vNGHQnUldnO?=
 =?us-ascii?q?uO+XGPtJg6rYPjl4QUSr9HT1w4DfIaCkJ5HNMcJJd7RC8rkbmejMQQ/3qxsA?=
 =?us-ascii?q?HRRNlGvpDATv+SGfXvKDedjblFfxsE26j3IZ4PNo3h2kxtdkV1k57RFkrRW9?=
 =?us-ascii?q?BNvjNubgsurEpR93h+Sz5750WwIDOs5nBXXdW5kgQ3gUE2Ne8g+C3t6BEnJ1?=
 =?us-ascii?q?zFjCo2jEQ1397ihGbVOHTaLL2xRp1REyr5rVM2NNezeAt8a0WQ1wQwLzrNQf?=
 =?us-ascii?q?RTybBgb2FwlAjEuZZVAvlaZaxCfBIUg/qQYqN7/05br3Cc2UJf5ebDQaBnnQ?=
 =?us-ascii?q?8ufI/k+2lMwCp/fdU1IurWP6MPwV9O0PHd9hS03/w8lVdNb30G93mfLWtR5R?=
 =?us-ascii?q?0F?=
X-IPAS-Result: =?us-ascii?q?A2AhAAAnj/Zc/wHyM5BcChoBAQEBAQIBAQEBBwIBAQEBg?=
 =?us-ascii?q?VQCAQEBAQsBgWYqgTcFMoQ8kwhMAQEBAQEBBoEICCV+iFKRCAkBAQEBAQEBA?=
 =?us-ascii?q?QE0AQIBAYRAAoJSIzcGDgEDAQEBBAEBAQEDAQFsKII6KQGCZgEBAQECASMEE?=
 =?us-ascii?q?UEQCxUBAgICJgICVwYNCAEBF4JIP4F3BQ+nTX4zhUeDKYFGgQwoAYtZF3iBB?=
 =?us-ascii?q?4ERJwyCKjU+hBkEE4MeglgEizyCMYU2VIEnkn1qCYIQghmRFwYblneNCpgxI?=
 =?us-ascii?q?oFYKwgCGAghD4MoghoXjjwjA4E2AQGNeAElgiwBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 04 Jun 2019 15:33:47 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x54FXjtD001017;
        Tue, 4 Jun 2019 11:33:45 -0400
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
 <20190603171549.GE13384@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <10a49f97-b3be-ed09-2821-68157f01aebe@tycho.nsa.gov>
Date:   Tue, 4 Jun 2019 11:33:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/3/19 2:30 PM, Xing, Cedric wrote:
>> From: Christopherson, Sean J
>> Sent: Monday, June 03, 2019 10:16 AM
>>
>> On Sun, Jun 02, 2019 at 12:29:35AM -0700, Xing, Cedric wrote:
>>> Hi Sean,
>>>
>>> Generally I agree with your direction but think ALLOW_* flags are
>>> completely internal to LSM because they can be both produced and
>>> consumed inside an LSM module. So spilling them into SGX driver and
>>> also user mode code makes the solution ugly and in some cases
>>> impractical because not every enclave host process has a priori
>>> knowledge on whether or not an enclave page would be EMODPE'd at
>> runtime.
>>
>> In this case, the host process should tag *all* pages it *might* convert
>> to executable as ALLOW_EXEC.  LSMs can (and should/will) be written in
>> such a way that denying ALLOW_EXEC is fatal to the enclave if and only
>> if the enclave actually attempts mprotect(PROT_EXEC).
> 
> What if those pages contain self-modifying code but the host doesn't know ahead of time? Would it require ALLOW_WRITE|ALLOW_EXEC at EADD? Then would it prevent those pages to start with PROT_EXEC?
> 
> Anyway, my point is that it is unnecessary even if it works.
> 
>>
>> Take the SELinux path for example.  The only scenario in which
>> PROT_WRITE is cleared from @allowed_prot is if the page *starts* with
>> PROT_EXEC.
>> If PROT_EXEC is denied on a page that starts RW, e.g. an EAUG'd page,
>> then PROT_EXEC will be cleared from @allowed_prot.
>>
>> As Stephen pointed out, auditing the denials on @allowed_prot means the
>> log will contain false positives of a sort.  But this is more of a noise
>> issue than true false positives.  E.g. there are three possible outcomes
>> for the enclave.
>>
>>    - The enclave does not do EMODPE[PROT_EXEC] in any scenario, ever.
>>      Requesting ALLOW_EXEC is either a straightforward a userspace bug or
>>      a poorly written generic enclave loader.
>>
>>    - The enclave conditionally performs EMODPE[PROT_EXEC].  In this case
>>      the denial is a true false positive.
>>
>>    - The enclave does EMODPE[PROT_EXEC] and its host userspace then fails
>>      on mprotect(PROT_EXEC), i.e. the LSM denial is working as intended.
>>      The audit log will be noisy, but viewed as a whole the denials
>> aren't
>>      false positives.
> 
> What I was talking about was EMODPE[PROT_WRITE] on an RX page.
> 
>>
>> The potential for noisy audit logs and/or false positives is unfortunate,
>> but it's (by far) the lesser of many evils.
>>
>>> Theoretically speaking, what you really need is a per page flag (let's
>>> name it WRITTEN?) indicating whether a page has ever been written to
>>> (or more precisely, granted PROT_WRITE), which will be used to decide
>>> whether to grant PROT_EXEC when requested in future. Given the fact
>>> that all mprotect() goes through LSM and mmap() is limited to
>>> PROT_NONE, it's easy for LSM to capture that flag by itself instead of
>> asking user mode code to provide it.
>>>
>>> That said, here is the summary of what I think is a better approach.
>>> * In hook security_file_alloc(), if @file is an enclave, allocate some
>> data
>>>    structure to store for every page, the WRITTEN flag as described
>> above.
>>>    WRITTEN is cleared initially for all pages.
>>
>> This would effectively require *every* LSM to duplicate the SGX driver's
>> functionality, e.g. track per-page metadata, implement locking to
>> prevent races between multiple mm structs, etc...
> 
> Architecturally we shouldn't dictate how LSM makes decisions. ALLOW_* are no difference than PROCESS__* or FILE__* flags, which are just artifacts to assist particular LSMs in decision making. They are never considered part of the LSM interface, even if other LSMs than SELinux may adopt the same/similar approach.
> 
> If code duplication is what you are worrying about, you can put them in a library, or implement/export them in some new file (maybe security/enclave.c?) as utility functions. But spilling them into user mode is what I think is unacceptable.
> 
>>
>>>    Open: Given a file of type struct file *, how to tell if it is an
>> enclave (i.e. /dev/sgx/enclave)?
>>> * In hook security_mmap_file(), if @file is an enclave, make sure
>> @prot can
>>>    only be PROT_NONE. This is to force all protection changes to go
>> through
>>>    security_file_mprotect().
>>> * In the newly introduced hook security_enclave_load(), set WRITTEN
>> for pages
>>>    that are requested PROT_WRITE.
>>
>> How would an LSM associate a page with a specific enclave?  vma->vm_file
>> will point always point at /dev/sgx/enclave.  vma->vm_mm is useless
>> because we're allowing multiple processes to map a single enclave, not
>> to mention that by mm would require holding a reference to the mm.
> 
> Each open("/dev/sgx/enclave") syscall creates a *new* instance of struct file to uniquely identify one enclave instance. What I mean is @vma->vm_file, not @vma->vm_file->f_path or @vma->vm_file->f_inode.
> 
>>
>>> * In hook security_file_mprotect(), if @vma->vm_file is an enclave,
>> look up
>>>    and use WRITTEN flags for all pages within @vma, along with other
>> global
>>>    flags (e.g. PROCESS__EXECMEM/FILE__EXECMOD in the case of SELinux)
>> to decide
>>>    on allowing/rejecting @prot.
>>
>> vma->vm_file will always be /dev/sgx/enclave at this point, which means
>> LSMs don't have the necessary anchor back to the source file, e.g. to
>> enforce FILE__EXECUTE.  The noexec file system case is also unaddressed.
> 
> vma->vm_file identifies an enclave instance uniquely. FILE__EXECUTE is checked by security_enclave_load() using @source_vma->vm_file. Once a page has been EADD'ed, whether to allow RW->RX depends on .sigstruct file (more precisely, the file backing SIGSTRUCT), whose FILE__* attributes could be cached in vma->vm_file->f_security by security_enclave_init().

The RFC series seemed to dispense with the use of the sigstruct file and 
just used the source file throughout IIUC.  That allowed for reuse of 
FILE__* permissions without ambiguity rather than introducing separate 
ENCLAVE__* permissions or using /dev/sgx/enclave inode as the target of 
all checks.

Regardless, IIUC, your approach requires that we always check 
FILE__EXECMOD, and FILE__EXECUTE up front during security_enclave_load() 
irrespective of prot so that we can save the result in the f_security 
for later use by the mprotect hook.  This may generate many spurious 
audit messages for cases where PROT_EXEC will never be requested, and 
users will be prone to just always allowing it since they cannot tell 
when it was actually needed.

>   
> The noexec case should be addressed in IOC_ADD_PAGES by testing @source_vma->vm_flags & VM_MAYEXEC.
> 
>>
>>> * In hook security_file_free(), if @file is an  enclave, free storage
>>>    allocated for WRITTEN flags.

