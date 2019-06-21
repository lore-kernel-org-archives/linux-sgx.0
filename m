Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02B4C43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885BD2084E
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfFUBgg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 21:36:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:31493 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBge (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 21:36:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:35:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="243825515"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by orsmga001.jf.intel.com with ESMTP; 20 Jun 2019 18:35:22 -0700
Date:   Fri, 21 Jun 2019 04:35:20 +0300
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
Subject: Re: [RFC PATCH v4 06/12] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20190621013520.GK20474@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-7-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:55PM -0700, Sean Christopherson wrote:
> SGX will use ->may_mprotect() to invoke an SGX variant of the existing
> file_mprotect() and mmap_file() LSM hooks.
> 
> The name may_mprotect() is intended to reflect the hook's purpose as a
> way to restrict mprotect() as opposed to a wholesale replacement.
> 
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, applying W^X restrictions on /dev/sgx/enclave using
> existing LSM hooks is for all intents and purposes impossible, e.g.
> denying either W or X would deny access to *any* enclave.
> 
> By hooking mprotect(), SGX can invoke an SGX specific LSM hook, which in
> turn allows LSMs to enforce W^X policies.
> 
> Alternatively, SGX could provide a helper to identify enclaves given a
> vma or file.  LSMs could then check if a mapping is for enclave and take
> action according.
> 
> A second alternative would be to have SGX implement its own LSM hooks
> for file_mprotect() and mmap_file(), using them to "forward" the call to
> the SGX specific hook.
> 
> The major con to both alternatives is that they provide zero flexibility
> for the SGX specific LSM hook.  The "is_sgx_enclave()" helper doesn't
> allow SGX can't supply any additional information whatsoever, and the
> mmap_file() hook is called before the final address is known, e.g. SGX
> can't provide any information about the specific enclave being mapped.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Absolutely nothing to say about this one. We can take it as part of the
main patch set as it is. Not going to apply it though before the things
have been sorted out.

/Jarkko
