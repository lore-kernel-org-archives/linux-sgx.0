Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7577C31E43
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FF0206C3
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbfFJQPe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:15:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:43609 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390990AbfFJQPe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 12:15:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 09:15:33 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 10 Jun 2019 09:15:32 -0700
Date:   Mon, 10 Jun 2019 09:15:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Message-ID: <20190610161532.GC15995@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <20190610152717.GB3752@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610152717.GB3752@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 06:27:17PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 05, 2019 at 07:11:42PM -0700, Sean Christopherson wrote:
> > [SNAP]
> 
> Same general criticism as for the previous patch: try to say things as
> they are without anything extra.
> 
> > A third alternative would be to pull the protection bits from the page's
> > SECINFO, i.e. make decisions based on the protections enforced by
> > hardware.  However, with SGX2, userspace can extend the hardware-
> > enforced protections via ENCLU[EMODPE], e.g. can add a page as RW and
> > later convert it to RX.  With SGX2, making a decision based on the
> > initial protections would either create a security hole or force SGX to
> > dynamically track "dirty" pages (see first alternative above).
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> 'flags' should would renamed as 'secinfo_flags_mask' even if the name is
> longish. It would use the same values as the SECINFO flags. The field in
> struct sgx_encl_page should have the same name. That would express
> exactly relation between SECINFO and the new field. I would have never
> asked on last iteration why SECINFO is not enough with a better naming.

No, these flags do not impact the EPCM protections in any way.  Userspace
can extend the EPCM protections without going through the kernel.  The
protection flags for an enclave page impact VMA/PTE protection bits.

IMO, it is best to treat the EPCM as being completely separate from the
kernel's EPC management.

> The same field can be also used to cage page type to a subset of values.
> 
> /Jarkko
