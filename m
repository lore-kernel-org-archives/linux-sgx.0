Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317B1C282CE
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEFA20811
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfDWBsE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 21:48:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:41111 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfDWBsE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 21:48:04 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 18:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,384,1549958400"; 
   d="scan'208";a="144988139"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 22 Apr 2019 18:48:02 -0700
Date:   Mon, 22 Apr 2019 18:48:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai <kai.huang@intel.com>, David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test
 new __vdso_sgx_enter_enclave() and its callback interface
Message-ID: <20190423014802.GA6749@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com>
 <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
 <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 06:29:06PM -0700, Andy Lutomirski wrote:
> On Mon, Apr 22, 2019 at 5:37 PM Cedric Xing <cedric.xing@intel.com> wrote:
> >
> > Given the changes to __vdso_sgx_enter_enclave(), the selftest is augmented to
> > test the newly added callback interface. This addtional test marks the whole
> > enclave range as PROT_READ, and calls mprotect() upon #PFs to add necessary PTE
> > permissions per PFEC (#PF Error Code) until the enclave finishes.
> 
> Nifty.
> 
> What's not tested here is running this code with EFLAGS.TF set and
> making sure that it unwinds correctly.  Also, Jarkko, unless I missed
> something, the vDSO extable code likely has a bug.  If you run the
> instruction right before ENCLU with EFLAGS.TF set, then do_debug()
> will eat the SIGTRAP and skip to the exception handler.  Similarly, if
> you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
> the code actually correct and am I just remembering wrong?

My money would be on the code being broken as opposed to you remembering
wrong.  I'll take a look at it tomorrow.
