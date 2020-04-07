Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5A1C2BA1A
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 16:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26C4020730
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 16:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDGQ5J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:57:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:16765 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgDGQ5J (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 12:57:09 -0400
IronPort-SDR: KpAJgP7B+L9E3ziBCeQ+EkGDO9qyLUOlgoRC05Q62nABuc/faGqIxOEPK9nNL+FCod2g358Vbb
 tzvltp7Vg1GQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 09:57:08 -0700
IronPort-SDR: 7JDqZ3qEZjc7+kM4h8k+z7dU3I0MrNltf5G9zWqeux/G+aDVhYxWK64XHkIfvrZRlNsX/iB2Ww
 fMYvjsHcla7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,355,1580803200"; 
   d="scan'208";a="451290963"
Received: from krausest-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.49])
  by fmsmga005.fm.intel.com with ESMTP; 07 Apr 2020 09:57:05 -0700
Date:   Tue, 7 Apr 2020 19:57:04 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200407165704.GA14583@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 07, 2020 at 12:04:58PM +0300, Topi Miettinen wrote:
> Please correct me if I'm wrong, but isn't it the goal of SGX to let a
> (suitably privileged) process designate some of its memory areas as part of
> SGX enclave? If so, why don't you simply add a system call to do so, such as
> 
> int sgx_mprotect(void *start, size_t length, int prot, u64 sgx_flags);
> 
> like existing pkey_mprotect()? Or add a flag PROT_SGX to mprotect() like
> existing PROT_SAO/PROT_SEM?
> 
> -Topi

New syscalls is always the last resort path, especially if they are
associated with an arch.

PROT_SGX sounds something worth of consideration.

Another idea to throw would be noexec_dev mount option that would allow
exec *only* for the device nodes (zero analysis done on feasibility).

/Jarkko
