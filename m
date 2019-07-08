Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2CAC606C1
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 15:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DFA020665
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 15:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbfGHPnx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 11:43:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:2023 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388244AbfGHPXq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 11:23:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 08:23:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="188524554"
Received: from jsakkine-mobl1.tm.intel.com ([10.237.50.189])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jul 2019 08:23:43 -0700
Message-ID: <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Date:   Mon, 08 Jul 2019 18:23:46 +0300
In-Reply-To: <20190707190809.GE19593@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-5-sean.j.christopherson@intel.com>
         <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
         <20190619152018.GC1203@linux.intel.com>
         <20190620221702.GE20474@linux.intel.com>
         <20190707190809.GE19593@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 2019-07-07 at 12:08 -0700, Sean Christopherson wrote:
> LGTM but why it isn't like:
> > 
> > __u16 mrmask;
> > __u8 prot;
> > __u8 reserved[5];
> 
> Because math is hard :-)  Though I think we'd want
> 
>   __u16 mrmask
>   __u8  prot
>   __u8  pad[5];
> 
> with an optional
> 
>   __u64 reserved[?];
> 
> "pad" can be ignored, e.g. doesn't need to be explicitly zeroed by
> userspace, whereas "reserved" requires explicit zeroing and probably an
> associated kernel check.

OK, cool with the change itself. Still need to get a better idea
how these make sense in architectural sense.

Things that would help with overall picture:

1. We have to figure out how this can be useful when LSM's are not used.
That gives at least some evidence that the security model is overally
good if it makes sense with and without LSM. Right now this looks like
dead functionality if not coupled with an LSM.
2. Probably some "user story" type of examples would help with the
discussion overall [1] i.e. how one would use this for
her own good.

[1] Probably many of the folks who work x86 tree have ignored major
    part of the discussion. Somehow these should be brought to
    nutshell so that anyone can get whatever the model is. Anyone
    should get it basically.

/Jarkko

