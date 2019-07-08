Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA21FC606BD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 16:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F4721537
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 16:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfGHQTd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 12:19:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:6288 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbfGHQTd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 12:19:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 09:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="340489623"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2019 09:19:32 -0700
Date:   Mon, 8 Jul 2019 09:19:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190708161932.GE20433@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com>
 <20190620221702.GE20474@linux.intel.com>
 <20190707190809.GE19593@linux.intel.com>
 <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 06:23:46PM +0300, Jarkko Sakkinen wrote:
> On Sun, 2019-07-07 at 12:08 -0700, Sean Christopherson wrote:
> > LGTM but why it isn't like:
> > > 
> > > __u16 mrmask;
> > > __u8 prot;
> > > __u8 reserved[5];
> > 
> > Because math is hard :-)  Though I think we'd want
> > 
> >   __u16 mrmask
> >   __u8  prot
> >   __u8  pad[5];
> > 
> > with an optional
> > 
> >   __u64 reserved[?];
> > 
> > "pad" can be ignored, e.g. doesn't need to be explicitly zeroed by
> > userspace, whereas "reserved" requires explicit zeroing and probably an
> > associated kernel check.
> 
> OK, cool with the change itself. Still need to get a better idea
> how these make sense in architectural sense.
> 
> Things that would help with overall picture:
> 
> 1. We have to figure out how this can be useful when LSM's are not used.

Declaring PROT_EXEC is useful to enforce noexec filesystems.  Beyond that,
I am not aware of any meaningful use case.

> That gives at least some evidence that the security model is overally
> good if it makes sense with and without LSM. Right now this looks like
> dead functionality if not coupled with an LSM.

I agree that it's effectively dead functionality without LSMs, but keep
in mind that this LSM rat hole was opened specifically because SGX could
be used to circumvent existing LSM security policies.  In other words,
the purpose of the UAPI extension is to achieve LSM compatibility without
incurring significant complexity in the LSM subsystem.

> 2. Probably some "user story" type of examples would help with the
> discussion overall [1] i.e. how one would use this for
> her own good.

The compelling story is Andy's original concern that userspace could
circumvent existing security policies by running code in an enclave.

AIUI, closing the LSM loophole is the minimal requirement to get SGX
upstreamed.  The extensive discussion has largely been focused on
ensuring that whatever mechanism is used to close the loophole will
play nice with future SGX functionality and/or LSM security policies.

> [1] Probably many of the folks who work x86 tree have ignored major
>     part of the discussion. Somehow these should be brought to
>     nutshell so that anyone can get whatever the model is. Anyone
>     should get it basically.
> 
> /Jarkko
> 
