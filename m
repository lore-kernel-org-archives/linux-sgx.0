Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9614C31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 16:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1D32070B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 16:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfFQQi6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:41077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQQi4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 12:38:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 09:38:55 -0700
X-ExtLoop1: 1
Received: from rameshr1-mobl.gar.corp.intel.com (HELO localhost) ([10.252.60.156])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2019 09:38:44 -0700
Date:   Mon, 17 Jun 2019 19:38:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Subject: Re: [RFC PATCH v2 5/5] security/selinux: Add enclave_load()
 implementation
Message-ID: <20190617163655.GA8710@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606021145.12604-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:11:45PM -0700, Sean Christopherson wrote:
> The goal of selinux_enclave_load() is to provide a facsimile of the
> existing selinux_file_mprotect() and file_map_prot_check() policies,
> but tailored to the unique properties of SGX.
> 
> For example, an enclave page is technically backed by a MAP_SHARED file,
> but the "file" is essentially shared memory that is never persisted
> anywhere and also requires execute permissions (for some pages).
> 
> The basic concept is to require appropriate execute permissions on the
> source of the enclave for pages that are requesting PROT_EXEC, e.g. if
> an enclave page is being loaded from a regular file, require
> FILE__EXECUTE and/or FILE__EXECMOND, and if it's coming from an
> anonymous/private mapping, require PROCESS__EXECMEM since the process
> is essentially executing from the mapping, albeit in a roundabout way.
> 
> Note, FILE__READ and FILE__WRITE are intentionally not required even if
> the source page is backed by a regular file.  Writes to the enclave page
> are contained to the EPC, i.e. never hit the original file, and read
> permissions have already been vetted (or the VMA doesn't have PROT_READ,
> in which case loading the page into the enclave will fail).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

In the end of the day, the main problem with this patch is that the
existing LSM hooks are generic. I don't we can have specific hooks
for proprietary hardware.

/Jarkko
