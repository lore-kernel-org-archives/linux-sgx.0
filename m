Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF9AC282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350DE20693
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfFDQ0L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 12:26:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:20667 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbfFDQ0K (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 12:26:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 09:26:10 -0700
X-ExtLoop1: 1
Received: from tvuori-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.210])
  by orsmga002.jf.intel.com with ESMTP; 04 Jun 2019 09:25:56 -0700
Date:   Tue, 4 Jun 2019 19:25:55 +0300
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
Subject: Re: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Message-ID: <20190604162555.GC3811@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531233159.30992-8-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 31, 2019 at 04:31:57PM -0700, Sean Christopherson wrote:
> Do not allow an enclave page to be mapped with PROT_EXEC if the source
> page is backed by a file on a noexec file system.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Why don't you just check in sgx_encl_add_page() that whether the path
comes from noexec and deny if SECINFO contains X?

/Jarkko
