Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D390FC04E84
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 21:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4D5020862
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558040597;
	bh=NO9G06JDTnmk7v8QHSnoMAUvRcyj/9lnX0RTiqK+xcY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cXUL+Wk5iw2QuSjKwRXoqm0fj80T1jdFAEnCVKh47dVpoDDbtO/ZGMYMTph2B9fl1
	 ML8INqtHlbXtWr9/yBwblImIjEPpI7WkOw6cuf+NX7S80AKz8Er2nMEzT5AcfVhUG+
	 h8G7TtW0hjv+stzGU0Pf6Vgd3krEi1JgSkSs9xnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfEPVDN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 17:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfEPVDN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 17:03:13 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778A32177B
        for <linux-sgx@vger.kernel.org>; Thu, 16 May 2019 21:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558040591;
        bh=NO9G06JDTnmk7v8QHSnoMAUvRcyj/9lnX0RTiqK+xcY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qn7kjHIprHMIS5LUTr8DlWiUs+osDXQecSfgGM4n7WqcqzpD718QXoaxS8kRobOec
         p7pxTTETmQDT/VHTsiOwVaDRH2dnZiltdz2QtPSWvKSkZwTjDoDEPK75R1gibc/AGc
         qn6Sby9LWJHIyRlmObLu5cGyHe1fDjUOzWX+Ka3A=
Received: by mail-wr1-f41.google.com with SMTP id d18so4865569wrs.5
        for <linux-sgx@vger.kernel.org>; Thu, 16 May 2019 14:03:11 -0700 (PDT)
X-Gm-Message-State: APjAAAVnIQwjEqAmOeoar2RSZ0upgwHWX5oeNXpuytzHYFaCRJLuFxtF
        UmNvS5RI/q4HFo1Of5M9kfNlEq04gdU0q+nxFGWxTg==
X-Google-Smtp-Source: APXvYqw1dYL01R+yjYjXnMkrG9YAOWLpm6jqnGKsVqFBcfXTj/mj24TqIWVrjrQnLHUKSSXbH0gRw3flducq2vGagig=
X-Received: by 2002:a5d:45c7:: with SMTP id b7mr9091972wrs.176.1558040589844;
 Thu, 16 May 2019 14:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190516051622.GC6388@linux.intel.com>
In-Reply-To: <20190516051622.GC6388@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 16 May 2019 14:02:58 -0700
X-Gmail-Original-Message-ID: <CALCETrVx1hgY67mP+73w5rT+eY+APcfS0YJ+XwtTLNz3CbVNMA@mail.gmail.com>
Message-ID: <CALCETrVx1hgY67mP+73w5rT+eY+APcfS0YJ+XwtTLNz3CbVNMA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On May 15, 2019, at 10:16 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
>
>> On Wed, May 15, 2019 at 11:27:04AM -0700, Andy Lutomirski wrote:
>> Hi, LSM and SELinux people-
>>
>> We're trying to figure out how SGX fits in with LSMs.  For background,
>> an SGX library is functionally a bit like a DSO, except that it's
>> nominally resistant to attack from outside and the process of loading
>> it is complicated.  To load an enclave, a program can open
>> /dev/sgx/enclave, do some ioctls to load the code and data segments
>> into the enclave, call a special ioctl to "initialize" the enclave,
>> and then call into the enclave (using special CPU instructions).
>>
>> One nastiness is that there is not actually a universally agreed upon,
>> documented file format for enclaves.  Windows has an undocumented
>> format, and there are probably a few others out there.  No one really
>> wants to teach the kernel to parse enclave files.
>>
>> There are two issues with how this interacts with LSMs:
>>
>> 1) LSMs might want to be able to whitelist, blacklist, or otherwise
>> restrict what enclaves can run at all.  The current proposal that
>> everyone seems to dislike the least is to have a .sigstruct file on
>> disk that contains a hash and signature of the enclave in a
>> CPU-defined format.  To initialize an enclave, a program will pass an
>> fd to this file, and a new LSM hook can be called to allow or disallow
>> the operation.  In a SELinux context, the idea is that policy could
>> require the .sigstruct file to be labeled with a type like
>> sgx_sigstruct_t, and only enclaves that have a matching .sigstruct
>> with such a label could run.
>
> Similarly if we could take data for the enclave from fd and enforce
> it with sgx_enclave_t label.

That certainly *could* be done, and I guess the decision could be left
to the LSMs, but I'm not convinced this adds value.  What security use
case does this cover that isn't already covered by requiring EXECUTE
(e.g. lib_t) on the enclave file and some new SIGSTRUCT right on the
.sigstruct?

>
>> Here's a very vague proposal that's kind of like what I've been
>> thinking over the past few days.  The SGX inode could track, for each
>> page, a "safe-to-execute" bit.  When you first open /dev/sgx/enclave,
>> you get a blank enclave and all pages are safe-to-execute.  When you
>> do the ioctl to load context (which could be code, data, or anything
>> else), the kernel will check whether the *source* VMA is executable
>> and, if not, mark the page of the enclave being loaded as unsafe.
>> Once the enclave is initialized, the driver will clear the
>> safe-to-execute bit for any page that is successfully mapped writably.
>
> With the fd based model for source I'd mark SECINFO.W pages as unsafe
> to execute and then check unsafe bit before applying lets say EMODT
> or EMODPR.
>
> There is a problem here though. Usually the enclave itself is just a
> loader that then loads the application from outside source and creates
> the executable pages from the content.
>
> A great example of this is Graphene that bootstraps unmodified Linux
> applications to an enclave:
>
> https://github.com/oscarlab/graphene
>

ISTM you should need EXECMEM or similar to run Graphene, then.
