Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3587C28CC6
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 11:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C43C524B72
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 11:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfFDLPl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 07:15:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:64072 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfFDLPl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 07:15:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 04:15:40 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jun 2019 04:15:33 -0700
Date:   Tue, 4 Jun 2019 14:15:33 +0300
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
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Message-ID: <20190604111533.GA15393@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 31, 2019 at 04:31:50PM -0700, Sean Christopherson wrote:
> This series is the result of a rather absurd amount of discussion over
> how to get SGX to play nice with LSM policies, without having to resort
> to evil shenanigans or put undue burden on userspace.  The discussion
> definitely wandered into completely insane territory at times, but I
> think/hope we ended up with something reasonable.

By definition this is a broken series because it does not apply to
mainline. Even RFC series should at least apply. Would be better idea to
discuss design ideas and use snippets instead. Now you have to take
original v20 and apply to these patches to evaluate anything.

> The basic gist of the approach is to require userspace to declare what
> protections are maximally allowed for any given page, e.g. add a flags
> field for loading enclave pages that takes ALLOW_{READ,WRITE,EXEC}.  LSMs
> can then adjust the allowed protections, e.g. clear ALLOW_EXEC to prevent
> ever mapping the page with PROT_EXEC.  SGX enforces the allowed perms
> via a new mprotect() vm_ops hook, e.g. like regular mprotect() uses
> MAY_{READ,WRITE,EXEC}.

mprotect() does not use MAY_{READ,WRITE,EXEC} constants. It uses
VM_MAY{READ,WRITE,EXEC,SHARED} constants.

What are ALLOW_{READ,WRITE,EXEC} and how they are used? What does the
hook do and why it is in vm_ops and not in file_operations? Are they
arguments to the ioctl or internal variables that are set based on
SECINFO?

/Jarkko
