Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA62C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E0721852
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbeLRPoT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:44:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:59200 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbeLRPoT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 10:44:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 07:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="101613051"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga006.jf.intel.com with ESMTP; 18 Dec 2018 07:44:18 -0800
Date:   Tue, 18 Dec 2018 07:44:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
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
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181218154417.GC28326@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com>
 <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 08:59:54PM -0800, Andy Lutomirski wrote:
> On Mon, Dec 17, 2018 at 2:20 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> 
> > My brain is still sorting out the details, but I generally like the idea
> > of allocating an anon inode when creating an enclave, and exposing the
> > other ioctls() via the returned fd.  This is essentially the approach
> > used by KVM to manage multiple "layers" of ioctls across KVM itself, VMs
> > and vCPUS.  There are even similarities to accessing physical memory via
> > multiple disparate domains, e.g. host kernel, host userspace and guest.
> >
> 
> In my mind, opening /dev/sgx would give you the requisite inode.  I'm
> not 100% sure that the chardev infrastructure allows this, but I think
> it does.

My fd/inode knowledge is lacking, to say the least.  Whatever works, so
long as we have a way to uniquely identify enclaves.

> > The only potential hiccup I can see is the build flow.  Currently,
> > EADD+EEXTEND is done via a work queue to avoid major performance issues
> > (10x regression) when userspace is building multiple enclaves in parallel
> > using goroutines to wrap Cgo (the issue might apply to any M:N scheduler,
> > but I've only confirmed the Golang case).  The issue is that allocating
> > an EPC page acts like a blocking syscall when the EPC is under pressure,
> > i.e. an EPC page isn't immediately available.  This causes Go's scheduler
> > to thrash and tank performance[1].
> 
> What's the issue, and how does a workqueue help?  I'm wondering if a
> nicer solution would be an ioctl to add lots of pages in a single
> call.

Adding pages via workqueue makes the ioctl itself fast enough to avoid
triggering Go's rescheduling.  A batched EADD flow would likely help,
I just haven't had the time to rework the userspace side to be able to
test the performance.

> >
> > Alternatively, we could change the EADD+EEXTEND flow to not insert the
> > added page's PFN into the owner's process space, i.e. force userspace to
> > fault when it runs the enclave.  But that only delays the issue because
> > eventually we'll want to account EPC pages, i.e. add a cgroup, at which
> > point we'll likely need current->mm anyways.
> 
> You should be able to account the backing pages to a cgroup without
> actually sticking them into the EPC, no?  Or am I misunderstanding?  I
> guess we'll eventually want a cgroup to limit use of the limited EPC
> resources.

It's the latter, a cgroup to limit EPC.  The mm is used to retrieve the
cgroup without having track e.g. the task_struct.
