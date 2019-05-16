Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08F9C04AAF
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 21:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B76216FD
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558040428;
	bh=Z9A5Gn8IYTN5zojnjOV85wLmycj3ctbS4IY7KKu9Mag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Tz6YtPj/DaouLMw2N3jAcqkhpOJdIfzR6xMxTEnhI5+GQgmBB79QvZpeJU9LK0aiQ
	 XMJWACIomPqVA3AcA7kS3RkL35KFgAakaKpeCHQa+rq+1kwfYHedNBBudZ1b1WId0J
	 LRDP+jl6sQjRdlL3ZNSavxeni+zJx0Hba55T5aNU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfEPVA2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 17:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbfEPVA2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 17:00:28 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2096C2173C
        for <linux-sgx@vger.kernel.org>; Thu, 16 May 2019 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558040427;
        bh=Z9A5Gn8IYTN5zojnjOV85wLmycj3ctbS4IY7KKu9Mag=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a7BgMrGtgZnxHAYWSt6S3/k/FkXM/xyFOY56aB6mNWaH59iedF30vLtmnsAne7bNK
         pKHgIPsdDoRnyTfZ8983ZTrMtZJvfYHnnPark1FEHJRh/BhMHtCldpFwiRsbWhGsNc
         nwnxYdF8x9KNOmpmWOAp4pzRESsYLYIpNOTVGbtY=
Received: by mail-wm1-f51.google.com with SMTP id i3so4941523wml.4
        for <linux-sgx@vger.kernel.org>; Thu, 16 May 2019 14:00:27 -0700 (PDT)
X-Gm-Message-State: APjAAAWgS19eEB+AUUm2AnSeIJwyaBw8kiiYDArGLr3ItjJGdd4L+K9O
        6HMgDRn9gmGshj1SQkn8WtHPuVud8/FdU+9YfwLDyg==
X-Google-Smtp-Source: APXvYqxyFCPtUJy1tK3AM0Pm9A3oAjys0XNTVLpwx7SvFZrupH0Xadu93+oLK89qkXjq20GSFTKUjie9fJ9+xPJMs2o=
X-Received: by 2002:a1c:9689:: with SMTP id y131mr30689877wmd.74.1558040425543;
 Thu, 16 May 2019 14:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org> <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org> <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <alpine.LRH.2.21.1905161716460.23647@namei.org>
In-Reply-To: <alpine.LRH.2.21.1905161716460.23647@namei.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 16 May 2019 14:00:13 -0700
X-Gmail-Original-Message-ID: <CALCETrXb7R-5Uq5Wg2bS1mGBp5bor78LBAbosOtp3ZCpFMAsrQ@mail.gmail.com>
Message-ID: <CALCETrXb7R-5Uq5Wg2bS1mGBp5bor78LBAbosOtp3ZCpFMAsrQ@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On May 16, 2019, at 12:24 AM, James Morris <jmorris@namei.org> wrote:
>
>> On Wed, 15 May 2019, Andy Lutomirski wrote:
>>
>>> On Wed, May 15, 2019 at 3:46 PM James Morris <jmorris@namei.org> wrote:
>>>
>>> You could try user.sigstruct, which does not require any privs.
>>>
>>
>> I don't think I understand your proposal.  What file would this
>> attribute be on?  What would consume it?
>
> It would be on the enclave file, so you keep the sigstruct bound to it,
> rather than needing a separate file to manage.  It would simplify any LSM
> policy check.
>
> It would be consumed by (I guess) the SGX_INIT_THE_ENCLAVE ioctl in your
> example, instead of having a 2nd fd.
>
>

Okay, I think I see what you=E2=80=99re suggesting. I don=E2=80=99t think i=
t works
well, though, since loading the data from the enclave file will almost
always be done in multiple chunks, and it=E2=80=99s not clear when the kern=
el
should look for the xattr or what to do if the xattr changes part way
through.
