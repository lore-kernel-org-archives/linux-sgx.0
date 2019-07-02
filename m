Return-Path: <SRS0=bK9D=U7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A7C5B578
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Jul 2019 02:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0852183F
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Jul 2019 02:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562034576;
	bh=sBZpHc2zXrpDRQDybsumjUZX90bQJCEO+Kk6c0bPMII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=08qC5dYbiPc5dZ7aF+Ax4HHfk3K07fUFzXRNMujqLcSUoYC+QyT/F1DZ0yhu3Up1C
	 3E0TCBy23uJStK4SSpp7SlMhSQQi9jdZrhMzUAL3YdkKMTQqIRqTdddTpRDOKpDOAr
	 PyebM5QBi58LjjYtKpVEAKDuZ3tFkGBrnCopJvCs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGBC3f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 22:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfGBC3f (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 22:29:35 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E45D21852
        for <linux-sgx@vger.kernel.org>; Tue,  2 Jul 2019 02:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562034574;
        bh=sBZpHc2zXrpDRQDybsumjUZX90bQJCEO+Kk6c0bPMII=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qRz2xpXyjh3TP2RntT6RcySMfpTWnvEjk4JtcbccgmYw7HfHjJ57un7T5SE0Ysu3W
         NhFfq4SmFsH50fAmRM0E4kUB8ZOueyBhRE7x40vIl6KSfjH8Me/SewH3LpHkcYzPfo
         aO4TGxCBWzeJM2ib1vomp16kJCX8tKVUCmYdkAww=
Received: by mail-wr1-f53.google.com with SMTP id n4so15900329wrs.3
        for <linux-sgx@vger.kernel.org>; Mon, 01 Jul 2019 19:29:33 -0700 (PDT)
X-Gm-Message-State: APjAAAUe1T2+jqVMISEE2b1B1e81A6zDT5/zbjDL9B2yWV72UJ21JMMe
        mD7a7BtnkcnTCSaa4l8JycM/r4vMccAcGsr2zkWfjg==
X-Google-Smtp-Source: APXvYqw33NmImx/Br19TU/TU77TdnBbURzCGpxBpz72W8JL+aUv4z+H4JfCRLmV1R3lv7yevjLJvwvSMk+oP0Ao0o8Q=
X-Received: by 2002:adf:a143:: with SMTP id r3mr11646705wrr.352.1562034572600;
 Mon, 01 Jul 2019 19:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com> <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D4B3@ORSMSX116.amr.corp.intel.com>
 <CALCETrUR=W3rfmG+qHydm0FQvASSYRt_V72v5WeQ4KWT7tjEdA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D5FA@ORSMSX116.amr.corp.intel.com>
 <CALCETrUAme7ujK3j-6gg1=_FtVGY3ZM8WBg9_9Sn-keywd7Smg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F6551D75B@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D75B@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 1 Jul 2019 19:29:21 -0700
X-Gmail-Original-Message-ID: <CALCETrVRDBN_AcKQaYbodtUVv5vW=s2bWP2OAucw=8OjhWo=ng@mail.gmail.com>
Message-ID: <CALCETrVRDBN_AcKQaYbodtUVv5vW=s2bWP2OAucw=8OjhWo=ng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 1, 2019 at 12:56 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Andy Lutomirski [mailto:luto@kernel.org]
> > Sent: Monday, July 01, 2019 12:36 PM
> >
> > On Mon, Jul 1, 2019 at 11:31 AM Xing, Cedric <cedric.xing@intel.com>
> > wrote:
> > > I intended to say the major reason I objected Sean's approach was its
> > inability to support SGX2 smoothly - as #PF driven EAUG requires non-
> > existent pages to be mmap()'ed, otherwise vm_ops->fault wouldn't be
> > dispatched so EAUG couldn't be issued in response to #PF.
> >
> > I still think that, if the kernel wants to support #PF-driven EAUG, it
> > should be an opt-in thing.  It would be something like
> > SGX_IOC_ADD_LAZY_EAUG_PAGES or similar.  If it's done that way, then
> > the driver needs to learn how to track ranges of pages efficiently,
> > which is another reason to consider leaving all the fancy page / page
> > range tracking in the driver.
> >
> > I don't think it's a good idea for a page fault on any non-EADDed page
> > in ELRANGE to automatically populate the page.
>
> I'm with you. The user code shall be explicit on which range to EAUG page=
s upon #PF. What I'm saying is, a range has to be mapped before the driver =
could receive #PFs (in the form of vm_ops->fault callbacks). But Sean's ser=
ies doesn=E2=80=99t support that because no pages can be mapped before comi=
ng into existence.
>
> For "page tracking", what information to track is LSM dependent, so it ma=
y run into problems if different LSMs want to track different things. And t=
hat's the major reason I think it should be done inside LSM.
>
> Besides, the current page tracking structure in the driver is page orient=
ed and its sole purpose is to serve #PFs. Page protection is better tracked=
 using range oriented structures. Those 2 are orthogonal. It wouldn't reduc=
e the complexity of the whole kernel by moving it into SGX driver.

It seems to me that the driver is going to need to improve its data
structures to track ranges of pages regardless of any LSM issues.  If
we're going to have an enclave with a huge ELRANGE and we're going to
mark some large subset of the full ELRANGE as allocate-on-demand, then
we are going to want to track that range in some efficient way.  It
could be a single extent or a set of power-of-two-sized extents (i.e.
radix tree entries), or something else, but a list of pages, of which
some are marked not-yet-allocated, isn't going to cut it.

Once that happens, it seems natural to put whatever permission
tracking we need into the same data structure.  That's why my proposal
had the driver getting coarse-grained info from LSM ("may execute
dirty page", for example) rather than asking the LSM to track the
whole state machine.

Does that make sense?
