Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44375C4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Aug 2021 19:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1773060F57
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Aug 2021 19:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhHLTxa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Aug 2021 15:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhHLTx3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Aug 2021 15:53:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A773B60C3E;
        Thu, 12 Aug 2021 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628797984;
        bh=TCwtM6BWv0H577BZzyIaqETTaYr/bgz/aJyZLq9lAls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NkKW9BUoAPhUftqcNV6MTHaY+EeyjqdCv1tF5z7IN9BOA97okh///miMz1rz5Cwot
         r+Ll3UP2iPGmzZwvPjqFU89T5KgM6u0GMiTQJpFpFj232+AojAFTePs/zyG6Wl1C4F
         Wjo1IzK34BeJ2wiBe+uvjWt58v4XNqXv1umO+9sGT8QI/hI2TAOmVFsFiVxBvgIofs
         mxT7Ik0aJllGLWH4Glw9OmmmSeGriwACOTlzE49r9zr5SVFM3uOqw/U8BHa8LFll1c
         ueOgUr4J//TrWrTSyuUc2hVnHV+PPlqGKItqj6YzPa1SNH9KDKhir0/3U2D6DqI03r
         /D62e/ePwFAxg==
Date:   Thu, 12 Aug 2021 22:53:01 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v3] x86/sgx: Add /proc/sys/kernel/sgx/total_mem
Message-ID: <20210812195301.jqnhvosfpqncl3jg@kernel.org>
References: <20210811032133.853680-1-jarkko@kernel.org>
 <0c935066-008d-b023-7dc3-f4e0ac1b3d20@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c935066-008d-b023-7dc3-f4e0ac1b3d20@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 11, 2021 at 07:30:13AM -0700, Dave Hansen wrote:
> On 8/10/21 8:21 PM, Jarkko Sakkinen wrote:
> > +The following sysctl files can be found in the ``/proc/sys/kernel/sgx/`` directory:
> > +
> > +``total_mem``
> > +	The total amount of SGX protected memory in bytes available in the system
> > +	available for use. In other words, it describes the size of the Enclave
> > +	Page Cache (EPC).
> 
> I've been acting as if /proc is deprecated for new stuff.  Shouldn't
> this be going in sysfs?

Are sysctl variables deprecated too?

> I figured, at some point, someone is going to ask for NUMA statistics.
> That would tend to point in the direction of us needing something in:
> 
> 	/sys/devices/system/node/nodeN/
> 
> Maybe 'sgxinfo' or 'sgxstat' to go along with 'meminfo'.

Is conetents of meminfo freezed or can a new line added, e.g.

Node 0 SgxMemTotal:    32825700 kB

If a new file is needed, I would name it as "sgxmeminfo"

> But, we'll probably also end up needing some stats for other things.
> Folks have, for instance, asked for a counter of the number of
> instantiated enclaves.
> 
> We could also use the drivers' namespaces:
> 
> 	/sys/class/misc/sgx_enclave
> 	/sys/class/misc/sgx_provision
> 	/sys/class/misc/sgx_vepc
> 
> although that is a bit awkward for reporting global resources like memory.

I think these stats should be available when the driver is not enabled.

It would be best to find a global solution for the long-run.

/Jarkko
