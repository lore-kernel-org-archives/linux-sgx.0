Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8B1C04EB8
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE1A22081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE1A22081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbeLJX0S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:26:18 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:53594 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbeLJX0S (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 10 Dec 2018 18:26:18 -0500
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 7FFF63A050E;
        Tue, 11 Dec 2018 00:25:04 +0100 (CET)
Received: from localhost (jfdmzpr03-ext.jf.intel.com [134.134.139.72])
        (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8B254200006;
        Mon, 10 Dec 2018 23:24:56 +0000 (UTC)
Date:   Mon, 10 Dec 2018 15:24:50 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Message-ID: <20181210232449.GA11843@localhost>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210232141.5425-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
> At that point I realized it's a hell of a lot easier to simply provide
> an IOCTL via /dev/sgx that allows userspace to register a per-process
> ENCLU exception handler.  At a high level, the basic idea is the same
> as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
> attempt to fixup select unhandled exceptions that occurred in user code.

So, on the one hand, this is *absolutely* much cleaner than the VDSO
approach. On the other hand, this is global process state and has some
of the same problems as a signal handler as a result.
