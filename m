Return-Path: <SRS0=hhxz=6W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8904FC35280
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 00:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E100208E4
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 00:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEHAZ4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 7 May 2020 20:25:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:64861 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgEHAZ4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 7 May 2020 20:25:56 -0400
IronPort-SDR: 6QnRC7/SMEyIKdIuZKgar/Wy2JG2/BWv7i7MZe0aCzo5J9/NpfC/hh2x0gmdMCPHxzS7s3YS7h
 gBBv+KyqUCBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 17:25:55 -0700
IronPort-SDR: prYshu7Xv9nQQs85m90ahwSYXcTuD251frmf7ulcP6LZ9JhJW+G7/15Rh6FEjjqQLDYJmJWjox
 PZPLlfgUGWUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="260706699"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 07 May 2020 17:25:55 -0700
Date:   Thu, 7 May 2020 17:25:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200508002555.GA24964@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
 <20200506221422.GK3329@linux.intel.com>
 <op.0j8dm0zzwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
 <CAOASepNVckens=wiWpHj291EAo0ndi7GCVHd9j7BPn8rjy7Ykg@mail.gmail.com>
 <20200507193459.GA24519@linux.intel.com>
 <op.0j9qdhziwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0j9qdhziwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 07, 2020 at 05:35:31PM -0500, Haitao Huang wrote:
> On Thu, 07 May 2020 14:34:59 -0500, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> >On Thu, May 07, 2020 at 12:49:15PM -0400, Nathaniel McCallum wrote:
> >>> For larger size mmap, I think it requires enabling vm overcommit mode
> >>1:
> >>> echo 1 | sudo tee /proc/sys/vm/overcommit_memory
> >
> >It shouldn't unless the initial mmap is "broken".  Not truly broken, but
> >broken in the sense that what Enarx is asking for is not actually what it
> >desires.
> >
> So I tried, this passes with mode 1 but fail with ENOMEM by default:
> 
> mmap(NULL, 0x100000000000UL, PROT_NONE, MAP_SHARED| MAP_ANONYMOUS, -1, 0);

Ah, fudge.  shmem_zero_setup() triggers shmem_acct_size() and thus
__vm_enough_memory().  Which I should have rememered because I've stared
at that code several times when dealing with the enclave's backing store.
I wasn't seeing the issue because I happened to use MAP_PRIVATE.

So, bad analysis, good conclusion, i.e. the kernel is still doing the
right thing, it's just not ideal for userspace.


Jarkko, we should update the docs and selftest to recommend and use

  PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS

or

  PROT_NONE, MAP_SHARED | MAP_NORESERVE | MAP_ANONYMOUS"

when carving out ELRANGE, with an explicit comment that all the normal
rules for mapping memory still apply.
