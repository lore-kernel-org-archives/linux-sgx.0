Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C674FC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956DB2183E
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553187055;
	bh=VFZVbyHAyA2I8iHvws801hJrn1l6FCnCEEx1Yui6u6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rH8E6T/1hbrV4EMGyadHdV69qnrzbJi2jhpToVvz/lB5ANOOpTK5sgeJeVWTGvLO2
	 k88evyxwmUS8JpNQqxpmp3z2Chg12kfV9g77RHRxr92mu5Xg2yoiMepb3iftU+cfqL
	 QXrvrcQhWhsjgvp/lBdtGJ/PtcGmI3UGmxPo68PQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfCUQuz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfCUQuz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 12:50:55 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C8DF21917
        for <linux-sgx@vger.kernel.org>; Thu, 21 Mar 2019 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553187054;
        bh=VFZVbyHAyA2I8iHvws801hJrn1l6FCnCEEx1Yui6u6M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=II5Qj7qLtNcvaQp9qtwyIxwE939N280XHF/BTW9nMXoPLIRXwzVORddoUOKKAkWv+
         yZHwLM9AgcbTI8hlbJM/Vow8ZRrqZdbkOBLhIwmZePBVMFZ3xXYWHZisXGumlW46kR
         wGhEBf1Ri6AOExNnaHRy/l2Mh4v+Y2AxxzORWgEE=
Received: by mail-wr1-f48.google.com with SMTP id q1so7441755wrp.0
        for <linux-sgx@vger.kernel.org>; Thu, 21 Mar 2019 09:50:54 -0700 (PDT)
X-Gm-Message-State: APjAAAVm93GZaPhCYT/4VjUwwV6F5G5hOk9QBP0SyPGdKceW+rxJtEVc
        0v3L/PK+dk9XTkYyQXdnehizRLbCw+uk6Txy19ilpQ==
X-Google-Smtp-Source: APXvYqwN9WAa0l9R5a/RKmQvkzuwqIPT6sCIg1Yv3y5V/7ApqBRZURKGxH5WCD3EOOxNBVzbRBTJrn+NX4+6zwaBWkw=
X-Received: by 2002:adf:f011:: with SMTP id j17mr152260wro.330.1553187052916;
 Thu, 21 Mar 2019 09:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com> <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 21 Mar 2019 09:50:41 -0700
X-Gmail-Original-Message-ID: <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
Message-ID: <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 2:18 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> In order to provide a mechanism for devilering provisoning rights:
>
> 1. Add a new file to the securityfs file called sgx/provision that works
>    as a token for allowing an enclave to have the provisioning privileges.
> 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
>    following data structure:
>
>    struct sgx_enclave_set_attribute {
>            __u64 addr;
>            __u64 token_fd;
>    };

Here's a potential issue:

For container use, is it reasonable for a container manager to
bind-mount a file into securityfs?  Or would something in /dev make
this easier?
