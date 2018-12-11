Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66209C07E85
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 15:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 266AC2084C
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 15:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 266AC2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbeLKPBx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:01:53 -0500
Received: from mga06.intel.com ([134.134.136.31]:52613 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbeLKPBx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 10:01:53 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2018 07:01:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,342,1539673200"; 
   d="scan'208";a="100651266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2018 07:01:52 -0800
Date:   Tue, 11 Dec 2018 07:01:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Message-ID: <20181211150152.GA14731@linux.intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
 <20181210232449.GA11843@localhost>
 <20181211145339.GA7528@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211145339.GA7528@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 08:53:39AM -0600, Dr. Greg wrote:
> On Mon, Dec 10, 2018 at 03:24:50PM -0800, Josh Triplett wrote:
> 
> Good morning to everyone, I hope the week is progressing well.
> 
> > On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
> > > At that point I realized it's a hell of a lot easier to simply provide
> > > an IOCTL via /dev/sgx that allows userspace to register a per-process
> > > ENCLU exception handler.  At a high level, the basic idea is the same
> > > as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
> > > attempt to fixup select unhandled exceptions that occurred in user code.
> 
> > So, on the one hand, this is *absolutely* much cleaner than the VDSO
> > approach. On the other hand, this is global process state and has
> > some of the same problems as a signal handler as a result.
> 
> Sean's architecture is very simple and straight forward and thus has a
> lot going for it.
> 
> As Sean's approach indicates, by linking the exception handler to
> current->mm, SGX is very much a per memory map concept.  The issue is
> that there can be multiple enclaves loaded and excecuting in a
> processes memory map, the problem is, execution and thus exception
> handling, is very much at the per thread level.

Right, but is there a need to have a per-thread code page?  The handler
isn't per-process any more than the AEP is per-process.
