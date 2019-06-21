Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11ECC43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 02:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA35206BA
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 02:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfFUC2S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 22:28:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:6289 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfFUC2S (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 22:28:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 19:28:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="181996563"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jun 2019 19:28:12 -0700
Date:   Fri, 21 Jun 2019 05:28:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map()
 hook for Intel SGX
Message-ID: <20190621022810.GL20474@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-8-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:56PM -0700, Sean Christopherson wrote:
> enclave_map() is an SGX specific variant of file_mprotect() and
> mmap_file(), and is provided so that LSMs can apply W^X restrictions to
> enclaves.
> 
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, applying W^X restrictions on /dev/sgx/enclave using
> existing LSM hooks is for all intents and purposes impossible, e.g.
> denying either W or X would deny access to any enclave.
> 
> Note, extensive discussion yielded no sane alternative to some form of
> SGX specific LSM hook[1].
> 
> [1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

All the non-LSM changes are almost cleared from my part.

I would suggest that we scrape v21 together as soon as you return from
your vacation discluding the LSM hooks.

There is no any particular reason to get the LSM changes to the mainline
before the SGX foundations so now is the right time close things
underlying them.

I'm now in the same boat with your changes to the ioctl API, which means
that we are ready to go. I feel a tiny bit bad that it took me so long
time with [1] but I'm a simple minded person so what I can do :-)

Once you can come back please deal with the suggestions that I made
and provide a "pure" SRCU patch (apologies for repeating myself). I
will the squash them to the existing patch set.

After that is fully done we can make v21 scope decision when it comes
to the enclave life-cycle.

Even if the LSM changes  would not be upstreamed as part of the
foundations I can start holding versions of them in my tree but only
after v21 is out.

Can you cope with this plan?

[1] https://patchwork.kernel.org/patch/11005431/

/Jarkko
