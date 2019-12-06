Return-Path: <SRS0=FYK3=Z4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CA8C2BBE2
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Dec 2019 20:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B588E2245C
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Dec 2019 20:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="Vq9KbSly"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfLFUiS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Dec 2019 15:38:18 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:58637 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfLFUiS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Dec 2019 15:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Ue6ST1C9P1tY1QLUauLPe7lfUfde9A/Tmm51Dk5Bko=; b=Vq9KbSlyUezdNuy+axSowJqc+I
        Hik7ks85MmhCKX5KvuSOu5+6a3DKasW8RTdc4uQzNP+uMxHgQZUhHUh7RVzd22u/IUsEXUPapwnb/
        gRZ59wV2+jVnwIek8LVXr5ggyWVPwTrp2gDVPNJET1PeQVG/V2si7/YC1q6jHrBSwFXWagtIqz9FX
        5w7MoryfQiWXpdhLxmwPAKfXEInCugyrY4Z3L0E/zj822D9Dh5DMEv0IWOD6juICAp0gF90E3mlyM
        wAAOBPoXfGdqO3FosdXr/CHJ1on+asPaANCu9+sacR4oFLWzHm1JHZ+m6+wcq3QEVpuq9RgrTgsff
        8oD+fjRQ==;
Received: from 91-154-92-5.elisa-laajakaista.fi ([91.154.92.5] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1idKMa-0006HJ-Tp; Fri, 06 Dec 2019 22:38:09 +0200
Date:   Fri, 6 Dec 2019 22:38:07 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191206203807.GA9971@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191128182450.GA3493127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128182450.GA3493127@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 91.154.92.5
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 28, 2019 at 07:24:50PM +0100, Greg KH wrote:
> On Mon, Oct 28, 2019 at 11:03:12PM +0200, Jarkko Sakkinen wrote:
> > +static struct device sgx_encl_dev;
> 
> Ugh, really?  After 23 versions of this patchset no one saw this?

Nobody has really given feedback on the device model. This is the
first review on that and thanks for taking your time. Previously
feeback has been mainly on the ioctl API and file management.

> > +static dev_t sgx_devt;
> > +
> > +static void sgx_dev_release(struct device *dev)
> > +{
> > +}
> 
> The old kernel documentation used to say I was allowed to make fun of
> people who did this, but that was removed as it really wasn't that nice.
> 
> But I'm seriously reconsidering that at the moment.
> 
> No, this is NOT OK!
> 
> Think about what you are doing here, and why you feel that it is ok to
> work around a kernel message that was added there explicitly to help you
> do things the right way.  I didn't add it just because I felt like it, I
> was trying to give you a chance to not get the use of this api
> incorrect.
> 
> That failed :(
> 
> Ugh, not ok.  Seriously, not ok...

It used to delete a context structure called sgx_dev_ctx. This structure
was removed in v20. I've failed to notice this when the code was refactored
for v20.

> Why a whole cdev?
> 
> Why not use a misc device?  YOu only have 2 devices right?  Why not 2
> misc devices then?  That saves the use of a whole major number and makes
> your code a _LOT_ simpler.

The downside would be that if we ever want to add sysfs attributes, that
could not be done synchronously with the device creation.

/Jarkko
