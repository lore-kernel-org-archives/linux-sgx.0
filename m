Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2303DC07E85
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 16:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A9D20851
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 16:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7A9D20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbeLKQwy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:52:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:1363 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbeLKQwy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 11:52:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2018 08:52:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,342,1539673200"; 
   d="scan'208";a="117757867"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Dec 2018 08:52:53 -0800
Date:   Tue, 11 Dec 2018 08:52:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Message-ID: <20181211165253.GB14731@linux.intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
 <20181210232449.GA11843@localhost>
 <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 07:41:27AM -0800, Andy Lutomirski wrote:
> 
> 
> > On Dec 10, 2018, at 3:24 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> >> On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
> >> At that point I realized it's a hell of a lot easier to simply provide
> >> an IOCTL via /dev/sgx that allows userspace to register a per-process
> >> ENCLU exception handler.  At a high level, the basic idea is the same
> >> as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
> >> attempt to fixup select unhandled exceptions that occurred in user code.
> > 
> > So, on the one hand, this is *absolutely* much cleaner than the VDSO
> > approach. On the other hand, this is global process state and has some
> > of the same problems as a signal handler as a result.
> 
> I liked the old version better for this reason 

This isn't fundamentally different than forcing all EENTER calls through
the vDSO, which is also per-process.  Technically this is more flexible
in that regard since userspace gets to choose where their one ENCLU gets
to reside.  Userspace can have per-enclave entry flows so long as the
actual ENLU[EENTER] is common, same as vDSO.

> and for another reason:
> while this new one looks very very simple, it still has the hidden
> complexity that the magic values written to registers in the event of an
> exception are very much Linux specific.

Definitely more magical, but not necessarily more difficult to document.
It'd essentially be an extension of hardware's AEE/AEP behavior.

> OTOH, the old approach clobbered more regs than needed, but that’s a easy fix.
