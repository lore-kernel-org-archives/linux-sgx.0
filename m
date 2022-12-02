Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D061C4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Dec 2022 22:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiLBW27 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Dec 2022 17:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiLBW24 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Dec 2022 17:28:56 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B6EBC95
        for <linux-sgx@vger.kernel.org>; Fri,  2 Dec 2022 14:28:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c15so6149999pfb.13
        for <linux-sgx@vger.kernel.org>; Fri, 02 Dec 2022 14:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mA7EbMY6jYQnBQ5a2EEJbPnWMt0mwJ2NvlH1bqAlVdY=;
        b=V060CW+9WaoNQd3JTJUfI6o9UkdRjdDPq8YkiSwizBRy26ilkRnNGJAXE7Vg9+lNlI
         2yoV5EBEzLEz03OO4J7or/HgCgJhox9GCPQSTfFmJl/8RH2WoDN4tpDIVB7c6tjjj1zw
         XpjdStemOWcnPqOer1QKZhSsCMKZ9rlqrOhavARkgcl9n0wfWmf1fpSwL9hSldz9SS2Q
         +S7s7eeJ4gTCgWzPJGljpfxS1WzJ/geX0nebjxdSA3dsEksaWk7t/oR7BC5dd7KrrXeT
         /mq07VibZtN+GbzY1ouUXHt/a9xxG1DhUAugzfWTojM3VFVZG3IlSe9RUyAoBjjhaMIa
         fEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mA7EbMY6jYQnBQ5a2EEJbPnWMt0mwJ2NvlH1bqAlVdY=;
        b=AorKcrYg52YGeMfDIAQw7op98rXMqryJWxmnvfkkp0XFtkN/hgauEWb2Zq4BbmbzRy
         C+dzZeiN8F1xWpN+8ck3F8aF0Zf08vYNstFBWN+NeRaVd9tQXEkUI0yy9wScH07JvlGh
         9rgbXeePyQ9ki7D3eZxl5VMshNjj8nEnFVCtHfVxYjEUhpk75OPQ3+ZIs4V3FmW/Z/6F
         WUyh63xXdWE+yg6hqPv5hP2QjyFLgAPg0oeoxGOlbZuc84O7wMNQaw5QiyImbgCJxKe2
         xt5xcu2zQkUIEleEFKrzMYDb+MHVaBbdNJv91H5gKeGYfi0b+GxDRxBafqRZirlvx2Oz
         psLA==
X-Gm-Message-State: ANoB5pk8qUJoI2J9m4Zyc2R2yfqYbwyl+e7VG5nXXJHXiTz0IxHiP5AM
        xQMP1NYctI4668eV6Hux0qGIcw==
X-Google-Smtp-Source: AA0mqf6uOp6LmsnTWIxJT0V0ir4lkWZqK0a+pL6GlLby9cQ/1qUsKnNUB7NKDQOcF0qmJT4HSWMCOw==
X-Received: by 2002:a63:e74a:0:b0:478:42f:5a3d with SMTP id j10-20020a63e74a000000b00478042f5a3dmr27833890pgk.3.1670020134604;
        Fri, 02 Dec 2022 14:28:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902710800b001891ad6eadasm5994649pll.251.2022.12.02.14.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:28:54 -0800 (PST)
Date:   Fri, 2 Dec 2022 22:28:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        zhiquan1.li@intel.com
Subject: Re: [PATCH v2 05/18] x86/sgx: Track epc pages on reclaimable or
 unreclaimable lists
Message-ID: <Y4p8IuxyVLw2YPNy@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-6-kristen@linux.intel.com>
 <1dccd2ec-cad8-b9d2-d66b-aebad21cdb44@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dccd2ec-cad8-b9d2-d66b-aebad21cdb44@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 02, 2022, Dave Hansen wrote:
> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> > Replace functions sgx_mark_page_reclaimable() and
> > sgx_unmark_page_reclaimable() with sgx_record_epc_page() and
> > sgx_drop_epc_page(). sgx_record_epc_page() wil add the epc_page
> > to the correct "reclaimable" or "unreclaimable" list in the
> > sgx_epc_lru_lists struct. sgx_drop_epc_page() will delete the page
> > from the LRU list. Tracking pages that are not tracked by
> > the reclaimer in the sgx_epc_lru_lists "unreclaimable" list allows
> > an OOM event to cause all the pages in use by an enclave to be freed,
> > regardless of whether they were reclaimable pages or not.
> 
> This might be more a comment about Sean's stuff

Anything with a single space after a period wasn't written by me, I'm a devout
believer of two spaces :-)
