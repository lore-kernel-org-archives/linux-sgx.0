Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDD1C31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C813020861
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 23:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560814993;
	bh=20LCI2udVS1+GC4MIM4kUTV0MsoEIVmoR3bcSnfEmjM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gVrIeRN4NjqE7lkWIR03KcsLNcCEVoK0noEaWKpVsjd/IuBzrE94Fm2qYf0eA74Ig
	 yzfPzutlv9+DF0ipv2GUcZ/MxvPDtvIE8R/bHb6JriHE6mZ2+osl84wqVHwxTZ+w+w
	 hMTmVY2PhxVeICSUPYNlHJwKdOmWZAuTxrw1ua8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFQXnN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 19:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfFQXnN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 19:43:13 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C03020B1F
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jun 2019 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560814992;
        bh=20LCI2udVS1+GC4MIM4kUTV0MsoEIVmoR3bcSnfEmjM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r5DJ+0d4KFD5Va+2HV6ciAOC0KbbfzBinkPCyGIsvRFIZxdpzbV766AXww+aIDmdn
         s32mrue+3TWIPU7nACS982JP2h4744nPg1033dPTR07MHwoGLJ5yHDrxhK9GQROrWQ
         OQgsAS5j20DMHrcd7FZ+XCyuanUTFV85FhsSM4Vs=
Received: by mail-wr1-f43.google.com with SMTP id p13so11826983wru.10
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jun 2019 16:43:12 -0700 (PDT)
X-Gm-Message-State: APjAAAU9Vu8w7p82lC/dAW+1IM+0UauZH4nGG25s9qjmRUwIozvoRDBY
        M8psjpQKnEgjlcjz0KUsKN7SZMJYhvlie9HtwX1z/A==
X-Google-Smtp-Source: APXvYqwIc0Uc8SEUuG89RGHgDedJ7LbcOFi1P4UFmGMfPatGup2AqynuqD/NLfXKapg7+U2tJbSu3aLgVDyqp5TCFnU=
X-Received: by 2002:adf:a443:: with SMTP id e3mr25414278wra.221.1560814991074;
 Mon, 17 Jun 2019 16:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190617222438.2080-1-sean.j.christopherson@intel.com> <20190617222438.2080-2-sean.j.christopherson@intel.com>
In-Reply-To: <20190617222438.2080-2-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 16:42:59 -0700
X-Gmail-Original-Message-ID: <CALCETrXgzzYXrMzcHEYiYE+tvCzU3vFErdzoDEMhMXN_qkQXQw@mail.gmail.com>
Message-ID: <CALCETrXgzzYXrMzcHEYiYE+tvCzU3vFErdzoDEMhMXN_qkQXQw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/12] x86/sgx: Add mm to enclave at mmap()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 17, 2019 at 3:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> The enclave mm tracking is currently broken:
>
>   - Adding current->mm during ECREATE is wrong as there is no guarantee
>     that the current process has mmap()'d the enclave, i.e. there may
>     never be an associated sgx_vma_close() to drop the encl_mm.
>
>   - Adding mm's at sgx_vma_open() is wrong as vm_ops->open is called
>     only when splitting or duplicating a vma.  If userspace performs a
>     single mmap() on the enclave then SGX will fail to track the mm.
>     This bug is partially hidden by tracking current->mm at ECREATE.
>
> Rework the tracking to get/add the mm at mmap().  A side effect of the
> bug fix is that sgx_vma_{open,close}() should never encounter a vma with
> an associated enclave and no associated encl_mm, i.e. WARN if an encl_mm
> cannot be found in either condition.
>

It would be nifty if you could also kill .vm_close, since then VMAs
could be merged properly.  Would this be straightforward?

--Andy
