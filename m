Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ACDF0
	for <linux-sgx@vger.kernel.org>; Sun, 26 Nov 2023 07:24:13 -0800 (PST)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5c1b9860846so5007943a12.2
        for <linux-sgx@vger.kernel.org>; Sun, 26 Nov 2023 07:24:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701012253; x=1701617053;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=ayd24ZoNCoQtL9EaPbr770Otgo5RLuspjrEKZjD+VjzGLhS1GRp5y5gK/ZFM0Q3ADr
         YJZEiqONqXMNSmqbG/+//pkyxlvP+hwV1D0DmrMpafDUBqGZtDSigvVodZQj8ZlFv39Y
         I9xn6wQiAZ8rZhqXVtZ4nDd5eryQiXxTEuH1MqwUt0B1sXLHb5lW2LPxloo1UWXASPNm
         pyBJrwd5xFJNIbiEH2x9baXInoTmuvIcoOdkvv0gttpeGsVorMqAhyINvcG4WDFZO2xH
         5rrtfQrg5Oi5HjRlkWTvJ1fSZNv2pFiR2EqSp8E1s2IDwlr/2waRhSTYdKJTYLfOp/Rl
         9rhg==
X-Gm-Message-State: AOJu0YxdKmsAtxWXaH0xPLNtevRalM+1Z0infb1ezW6t7Nmk+QjvqwKa
	mxXk46HbeBpBaDKO7QfVtUux8qtHYqKX8s+W5DjF59c0HJjN
X-Google-Smtp-Source: AGHT+IHAOAsVy5wek93F9Km67otZrKPfh/qWnTHeq/2VAW8gUxQGL4A7oqrdchvA1bvg38ODschC8brnjEtE8xUekYn4XzvjSKbl
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a63:e310:0:b0:5b9:63f2:e4cc with SMTP id
 f16-20020a63e310000000b005b963f2e4ccmr1497584pgh.2.1701012253177; Sun, 26 Nov
 2023 07:24:13 -0800 (PST)
Date: Sun, 26 Nov 2023 07:24:13 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bfd01060b0fc7dc@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com, 
	tglx@linutronix.de, usama.anjum@collabora.com, vkuznets@redhat.com, 
	wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: **

This bug is marked as fixed by commit:
KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux 5.15
Dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e

---
[1] I expect the commit to be present in:

1. linux-5.15.y branch of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
