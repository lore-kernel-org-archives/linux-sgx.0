Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4C9C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2272217D9
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545109208;
	bh=AG4tlnMowIVPi36C9DlXqpN0/XcJnQDiuOlazI8YETI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=I+1XL1GIGQtLEUixTsBovsbqYKu2FmBhW1eXi5TKzx0wlaRuZRXQzb8dhYT9Oy8z4
	 BrBhijF1+jB8cf1qEOq6VTuZvGDaSKfHoKAfp0zsWf09Gdbp/f8gP1aRvkV/HjzvDO
	 9qzDU9ne8WFil9pENjYeJX41qdSfWol5pfGqLe6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbeLRFAI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 00:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbeLRFAI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 00:00:08 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0590D218A1
        for <linux-sgx@vger.kernel.org>; Tue, 18 Dec 2018 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545109207;
        bh=AG4tlnMowIVPi36C9DlXqpN0/XcJnQDiuOlazI8YETI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2mbRLn2n++DxslDPl0Dbi1HJ1Qz01e3NJ0avuQy6JCKEPackH90ebuIZ4sChzNdNd
         bQGN1tK9EZCZUmcM336PbXRD8yNJCSd/qx24T22MfqfwkxSdDm8PZj0lzuA5XGxbdt
         gi/HleEfIqZ9yxUK5mHfPc+Bnz+E07ILtsFEAHEg=
Received: by mail-wm1-f45.google.com with SMTP id m22so1329798wml.3
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 21:00:06 -0800 (PST)
X-Gm-Message-State: AA+aEWYq4oYNYyBX4NSQ97Z0vcoBV+2YKOmasGKrfT0YyDK/d8g44n27
        PEsEIGOye/TCfQJUtrmtWNFM80nYjAqSC6YhBMmYvw==
X-Google-Smtp-Source: AFSGD/Ww5FWaXGKisvbGt6Ac7HAoRJwKqZyQEkbOFw7ju4a9c1pMszsYmb+UX7hVAEK7w3NQ0iuujy3GP5M9xaeRVKs=
X-Received: by 2002:a1c:b1d5:: with SMTP id a204mr1650822wmf.32.1545109205298;
 Mon, 17 Dec 2018 21:00:05 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com> <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com> <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com> <20181217222047.GG12491@linux.intel.com>
In-Reply-To: <20181217222047.GG12491@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 20:59:54 -0800
X-Gmail-Original-Message-ID: <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
Message-ID: <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 2:20 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>

> My brain is still sorting out the details, but I generally like the idea
> of allocating an anon inode when creating an enclave, and exposing the
> other ioctls() via the returned fd.  This is essentially the approach
> used by KVM to manage multiple "layers" of ioctls across KVM itself, VMs
> and vCPUS.  There are even similarities to accessing physical memory via
> multiple disparate domains, e.g. host kernel, host userspace and guest.
>

In my mind, opening /dev/sgx would give you the requisite inode.  I'm
not 100% sure that the chardev infrastructure allows this, but I think
it does.

> The only potential hiccup I can see is the build flow.  Currently,
> EADD+EEXTEND is done via a work queue to avoid major performance issues
> (10x regression) when userspace is building multiple enclaves in parallel
> using goroutines to wrap Cgo (the issue might apply to any M:N scheduler,
> but I've only confirmed the Golang case).  The issue is that allocating
> an EPC page acts like a blocking syscall when the EPC is under pressure,
> i.e. an EPC page isn't immediately available.  This causes Go's scheduler
> to thrash and tank performance[1].

What's the issue, and how does a workqueue help?  I'm wondering if a
nicer solution would be an ioctl to add lots of pages in a single
call.

>
> Alternatively, we could change the EADD+EEXTEND flow to not insert the
> added page's PFN into the owner's process space, i.e. force userspace to
> fault when it runs the enclave.  But that only delays the issue because
> eventually we'll want to account EPC pages, i.e. add a cgroup, at which
> point we'll likely need current->mm anyways.

You should be able to account the backing pages to a cgroup without
actually sticking them into the EPC, no?  Or am I misunderstanding?  I
guess we'll eventually want a cgroup to limit use of the limited EPC
resources.
